class AgendaController < ApplicationController
  
  before_filter :authenticate_user
  
  def index
    # Finds all public and private events that I have joined
    @events = Event.find(:all, :joins => [:memberships], :conditions => ["events.id = memberships.event_id and memberships.user_id = ?", current_user.id])
    #@events = Event.find(:all, :conditions=>"memberships.user_id == #{current_user.id}",
    #                    :joins=>" INNER JOIN memberships ON events.id = memberships.event_id")
    
    # Find all memberships that the user has joined
    @events_by_date = @events.group_by(&:start_date)
    @date = params[:date] ? Date.strptime(params[:date], "%Y-%m-%d") : Date.today
  end
end
