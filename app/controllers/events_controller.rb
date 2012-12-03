class EventsController < ApplicationController
  
  before_filter :authenticate_user
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    @event.user_id = current_user.id
    
    if @event.save
      
        event = Event.find_by_id(@event.id)
        membership = event.memberships.build(:event_id => event.id, :user_id => current_user.id)
        
        if membership.save
          redirect_to events_index_path, :notice => "Event created!"
        else
          redirect_to events_index_path, :notice => "Unable to create event!"
          #render :action => 'new'
        end
    else
      render "new"
    end
  end

  def update
  end

  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    event = Event.find(params[:event][:id])
    event.name = params[:event][:name]
    event.location = params[:event][:location]
    event.public = params[:event][:public]
    
    
    if event.save
      respond_to do |format|
        format.html { redirect_to events_index_path, :notice => "Event updated!"}
        format.xml  { head :no_content }
      end
    else
      redirect_to events_index_path, :notice => "Event update failed!"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.user_id = current_user.id
      @event.destroy
    end

    respond_to do |format|
      format.html { redirect_to events_index_path, :notice => "Event deleted!"}
      format.xml  { head :no_content }
    end
  end

  def index
    @event = Event.find_all_by_public(1)
    #@event.delete_if {|x| x.public == 0}
    
    # Finds all events made by the current_user
    @p_event = Event.find_all_by_user_id(current_user.id)
    #@event = Event.find_by_public(1)
    # fix later: @event = Event.where(["public = 0 OR user_id= current_user" ]).all
    
    friends = current_user.all_friends
    @private_events = Event.find(:all, :joins => [:memberships], :conditions => ["events.public = 0 and events.user_id IN (?) AND events.user_id = memberships.user_id", friends])
    # fix later: @event = Event.where(["public = 0 OR user.id= current_user" ]).all

#   change to  @temp = Mymodel.find(:all, :conditions => ['contents = ? AND
# => apprflag <> 0', session[:searchstr])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event }
      format.json  { render :json => @event }
    end
  end

  def show
    @event = Event.find(params[:id])
    
    @event_memberships = User.find(:all, :select => "f_name, l_name, user_id", :joins => [:memberships], :conditions => ["memberships.event_id = ? AND users.id = memberships.user_id", @event])
    
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @event }
      format.json  { render :json => @event }
    end
  end
  
  def search
    if params[:search]
      @results = Event.find(:all, :conditions => ['name || location || username LIKE ?', "%#{params[:search.downcase]}%"])
    else
      @results = []
    end
  end
  
  # lindsaar.net
  def feed
    @title = "CountMeIn Public Events"
    
    # Already ordered via model
    @events = Event.find_all_by_public(1)
    
    @updated = @events.first.updated_at unless @events.empty?
    
    respond_to do |format|
      format.atom { render :layout => false }
      format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
   end
   
  end
end
