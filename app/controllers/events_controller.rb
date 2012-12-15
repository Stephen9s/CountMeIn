class EventsController < ApplicationController
  
  before_filter :authenticate_user, :except => [:feed]
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    @event.user_id = current_user.id
    
    if @event.save
      
        event = Event.find_by_id(@event.id)
        membership = event.memberships.build(:event_id => event.id, :user_id => current_user.id, :owner_id => current_user.id)
        
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
    memberships = Membership.find_all_by_event_id(params[:id])
    if @event.user_id = current_user.id
      @event.destroy
      
      memberships.each do |r|
        r.destroy
      end
      
      respond_to do |format|
        format.html { redirect_to events_index_path, :notice => "Event deleted!"}
        format.xml  { head :no_content }
      end
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

    if !Event.exists?(params[:id])
      redirect_to(:controller => 'sessions', :action => 'logout')
    else
      @event = Event.find(params[:id])
      @event_memberships = User.find(:all, :select => "f_name, l_name, user_id", :joins => [:memberships], :conditions => ["memberships.event_id = ? AND users.id = memberships.user_id", @event], :order => "l_name ASC")
      @verify_auth_token_date = Authentication.find_by_user_id(current_user.id, :select => "expires_at")
      @google_id = Membership.find_by_user_id_and_event_id(current_user.id, params[:id], :select => "google_event_id")
      friendship = current_user.friendships.find_by_friend_id(@event.user_id)
      membership = current_user.memberships.find_by_user_id(current_user.id)
      
      if (@event.public == 0 && !friendship && !membership)
        redirect_to(:controller => 'sessions', :action => 'logout')
      else
        respond_to do |format|
          format.html # index.html.erb
          #format.xml  { render :xml => @event }
          format.json  { render :json => @event }
        end
      end
    end
  end
  
  def search

    if params[:search_events] != ""
      #@results = Event.find(:all, :conditions => ['name || location LIKE ?', "%#{params[:search_events.downcase]}%"])
      friends = current_user.all_friends + current_user.all_inverse_friends
      friends_id = Array.new
      #friends_id << current_user.id
      friends.each do |friend|
        friends_id << friend.id
      end
      
      # Finds ALL public events; friends or not.
      if params[:search_events] == "?"
        public_events = Event.find(:all, :conditions => ["public = 1"])
      else
        public_events = Event.find(:all, :conditions => ["public = 1 and (name || location LIKE ?)", "%#{params[:search_events.downcase]}%"])
      end
      
      # Finds ALL private events; must be friends.
      if params[:search_events] == "?"
        @results = Event.find(:all, :conditions => [ "user_id IN (?) and public = 0",friends_id], :order => "updated_at DESC")
      else
        @results = Event.find(:all, :conditions => [ "user_id IN (?) and (name || location LIKE ?) and public = 0", friends_id, "%#{params[:search_events.downcase]}%"], :order => "updated_at DESC")
      end
      
      @results = (@results + public_events).sort_by(&:updated_at)
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
