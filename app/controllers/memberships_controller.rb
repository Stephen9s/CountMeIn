class MembershipsController < ApplicationController
  
  before_filter :authenticate_user
  
  def create
    event = Event.find_by_id(params[:event_id])
    membership = event.memberships.build(:event_id => params[:event_id], :user_id => current_user.id, :owner_id => event.user_id)
    
    if membership.save
      redirect_to event_path(params[:id]), :notice => "Event joined!"
    else
      redirect_to events_path, :notice => "Unable to join event!"
      #render :action => 'new'
    end
  end
  
  def destroy
    @membership = Membership.find_by_user_id_and_event_id(current_user.id, params[:id])
    
    if @membership.destroy
      redirect_to event_path(params[:id]), :notice => "You have left the event."
    else
      redirect_to events_path, :notice => "Can't go."
    end
  end
  
end
