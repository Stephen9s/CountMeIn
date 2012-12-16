class MembershipsController < ApplicationController
  
  before_filter :authenticate_user
  
  def create
    event = Event.find_by_id(params[:event_id])
    membership = event.memberships.build(:event_id => params[:event_id], :user_id => current_user.id, :owner_id => event.user_id)
    
    if membership.save
      redirect_to show_event_path(params[:event_id]), :notice => "Event joined!"
    else
      redirect_to show_event_path(params[:event_id]), :notice => "Unable to join event!"
      #render :action => 'new'
    end
  end
  
  def destroy
    @membership = Membership.find_by_user_id_and_event_id(current_user.id, params[:id])
    
    if @membership.destroy
      redirect_to show_event_path(params[:id]), :notice => "You have left the event."
    else
      redirect_to show_event_path(params[:id]), :notice => "You haven't left the event yet; there was an error."
    end
  end
  
end
