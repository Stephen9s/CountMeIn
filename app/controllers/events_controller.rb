class EventsController < ApplicationController
  
  before_filter :authenticate_user
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    
    if @event.save
      flash[:notice] = "Event successfull created!"
      flash[:color] = "valid"
      
      # if created, then don't ask them to create another one...
      # redirect to login
      redirect_to :controller => 'events', :action => 'index'
    else
      flash[:notice] = "Form is invalid"
      flash[:color] = "invalid"
      render "new"
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def index
    @event = Event.all
    @event.each do |event|
      if event.public?
        @event = @event.to_a.pop event
      end
    end

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
