class EventsController < ApplicationController
  
  before_filter :authenticate_user
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    @event.user_id = current_user
    
    if @event.save
      redirect_to :controller => 'events', :action => 'index'
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
    if @event.user_id = current_user.id
      @event.destroy
    end

    respond_to do |format|
      format.html { events_path }
      format.xml  { head :no_content }
    end
  end

  def index
    @event = Event.find_all_by_public(1)
    #@event.delete_if {|x| x.public == 0}
    
    @p_event = Event.find_all_by_user_id(current_user)
    #@event = Event.find_by_public(1)
    # fix later: @event = Event.where(["public = 0 OR user_id= current_user" ]).all

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
