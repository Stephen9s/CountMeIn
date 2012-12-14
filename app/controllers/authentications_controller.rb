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
    
    
    if (have_cal!)
      
      @token = @auth["credentials"]["token"]
      client = Google::APIClient.new
      client.authorization.access_token = @token
      service = client.discovered_api('calendar', 'v3')
      @result = client.execute(
        :api_method => service.calendars.insert,
        :body_object => {'summary' => 'Count me in!'},
        :headers => {'Content-Type' => 'application/json'}) 
      
      @authentication.cal_id = @result.data.id.to_s
      @authentication.save
    end
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
    google = Authentication.find_by_user_id(current_user.id)
    
    
    @event = Event.find_by_id(params[:event_id])
    
    to_post = {
      'summary' => @event.name,
      'location' => @event.location,
      'start' => {
        'dateTime' => @event.start_date.to_datetime
        },
      'end' => {
        'dateTime' => @event.end_date.to_datetime
        }
      }
    
    
    client = Google::APIClient.new
    client.authorization.access_token = @google["credentials"]["token"]
    service = client.discovered_api('calendar', 'v3')
    @result = client.execute(
      :api_method => service.calendars.insert,
      :parameters => {'calendarId' => google.cal_id},
      :body => JSON.dump(to_post),
      :headers => {'Content-Type' => 'application/json'})
      
      
      membership = Membership.find_by_user_id_and_event_id(current_user.id, params[:event][:id])
      membership.google_event_id = @result.data.id
      
      respond_to do |format|
        format.html { redirect_to events_index_path, :notice => "Event added to gogole Cal!"}
        format.xml  { head :no_content }
      end
  end
  
  def remove_event
    google = Authentication.find_by_user_id(current_user.id)
    event = Event.find_by_id(params[:event_id])
    membership = Membership.find_by_user_id_and_event_id(current_user.id, params[:event][:id])
    
    client = Google::APIClient.new
    client.authorization.access_token = @google["credentials"]["token"]
    service = client.discovered_api('calendar', 'v3')
    @result = client.execute(
      :api_method => service.events.delete,
      :parameters => {'calendarId' => google.cal_id, 'eventId' => membership.google_event_id},
      :headers => {'Content-Type' => 'application/json'})
      
      respond_to do |format|
        format.html { redirect_to events_index_path, :notice => "Event removed from google cal!"}
        format.xml  { head :no_content }
      end
  end
end
