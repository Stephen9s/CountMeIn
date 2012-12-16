class AuthenticationsController < ApplicationController
  def create
    @auth = request.env["omniauth.auth"]
    @authentication = Authentication.find_or_create_by_user_id(current_user.id)
    @authentication.user_id = current_user.id
    @authentication.provider = @auth["provider"]
    @authentication.uid = @auth["uid"]
    @authentication.token = @auth['credentials']['token']
    @authentication.refresh_token = @auth['credentials']['refresh_token']
    @authentication.expires_at = Time.at(@auth['credentials']["expires_at"].to_f).to_datetime - 30.seconds
    @authentication.save
      
    @token = @auth["credentials"]["token"]
    client = Google::APIClient.new
    client.authorization.access_token = @token
    service = client.discovered_api('calendar', 'v3')
    
    if @authentication.cal_id == "" || @authentication.cal_id.nil?
      @result = client.execute(
        :api_method => service.calendars.insert,
        :body_object => {'summary' => 'Count me in!'},
        :headers => {'Content-Type' => 'application/json'}) 
      @authentication.cal_id = @result.data.id.to_s
    end
    
    @authentication.save
    
    redirect_to profile_path, :notice => "Successfully logged in to Google!"
  end
  
  def have_cal
    google = Authentication.find_or_by_user_id(current_user.id)
    if (google.cal_id == null)
      return false
    end
    return true
  end
  
  def token_check
    @google = Authentication.find_or_by_user_id(current_user.id)
    
  end
  
  def add_event
    @google = Authentication.find_by_user_id(current_user.id)
    
    
    @event = Event.find_by_id(params[:id])
    
    start_date = Date.parse((@event.start_date).to_s)
    end_date = Date.parse((@event.end_date).to_s)
    v = start_date.strftime('%Y-%m-%d')
    x = end_date.strftime('%Y-%m-%d')
    to_post = {
      'summary' => @event.name,
      'location' => @event.location,
      'start' => {
        'date' => v
        },
      'end' => {
        'date' => x
        }
      }
    string1 = '#{@event.name} + at + #{@event.location} + on + #{@event.start_date.to_datetime}'
    
    client = Google::APIClient.new
    client.authorization.access_token = @google.token
    service = client.discovered_api('calendar', 'v3')
    @result = client.execute(
      :api_method => service.events.insert,
      :parameters => {'calendarId' => @google.cal_id},
      :body => JSON.dump(to_post),
      :headers => {'Content-Type' => 'application/json'})
      
      
      membership = Membership.find_by_user_id_and_event_id(current_user.id, params[:id])
      membership.google_event_id = @result.data.id
    
    if membership.save && @result
      redirect_to show_event_path(params[:id]), :notice => "Event added to your Google Cal!"
    else
      redirect_to show_event_path(params[:id]), :notice => "Error adding to Google Cal!"
    end
      
  end
  
  def show
    @result = :result
  end
  
  def remove_event
    @google = Authentication.find_by_user_id(current_user.id)
    @event = Event.find_by_id(params[:id])
    membership = Membership.find_by_user_id_and_event_id(current_user.id, params[:id])
    
    client = Google::APIClient.new
    client.authorization.access_token = @google.token
    service = client.discovered_api('calendar', 'v3')
    @result = client.execute(
      :api_method => service.events.delete,
      :parameters => {'calendarId' => @google.cal_id, 'eventId' => membership.google_event_id},
      :headers => {'Content-Type' => 'application/json'})
    
    membership.google_event_id = ""
    
    if membership.save && @result
      redirect_to show_event_path(params[:id]), :notice => "Event removed from your Google Cal!"
    else
      redirect_to show_event_path(params[:id]), :notice => "Error removing event from Google Cal!"
    end
      
  end
end
