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

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
  end

  def index
    
    @event = Event.all
    @event.delete_if {|x| x.public == 0}
    # fix later: @event = Event.where(["public = 0 OR user.id= current_user" ]).all

#   change to  @temp = Mymodel.find(:all, :conditions => ['contents = ? AND
# => apprflag <> 0', session[:searchstr])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def show
    @event = Event.find(params[:id])
  end
  
  def search
    if params[:search]
      @results = Event.find(:all, :conditions => ['name || location || username LIKE ?', "%#{params[:search.downcase]}%"])
    else
      @results = []
    end
  end
  
end
