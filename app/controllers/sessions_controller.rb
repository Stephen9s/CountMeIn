class SessionsController < ApplicationController
  
  before_filter :authenticate_user, :except => [:index, :login, :login_attempt, :logout]
  before_filter :save_login_state, :only => [:index, :login, :login_attempt] 
  
  def login
    
  end
  
  def login_attempt
    
    authorized_user = User.authenticate(params[:username_or_email], params[:login_password])
    
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "Welcome back, #{authorized_user.username}"
      redirect_to(:action => 'home')
    else
      flash[:notice] = "Invalid username or password."
      flash[:color] = "invalid"
      render "login"
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out!"
    redirect_to :action => 'login'
  end

  def home   
    friends = current_user.all_friends + current_user.all_inverse_friends
    friends_id = Array.new
    #friends_id << current_user.id
    friends.each do |friend|
      friends_id << friend.id
    end
    
    begin
      @events = Event.find(:all, :conditions => [ "user_id IN (?)", friends_id], :order => "updated_at DESC")
    rescue ActiveRecord::RecordNotFound
      @events = []
    end
    
    @json_events = @events.clone
    
    @json_events.each do |event|
      user = User.find(event.user_id, :select => "username", :limit => 1)
      event.username = user.username
    end
 
    # Add username to json format
    respond_to do |format|
      format.json  { render :json => @json_events.as_json(:methods => [:username]) }
      format.html {}
    end
  end

  def profile
    @profile = User.find(session[:user_id], :select => "username, email, f_name, l_name, mobile_phone, dob, gender, description, email", :limit => 1)
  end

  def setting
  end
  
  def friends
    @friends = current_user.all_friends + current_user.all_inverse_friends
    @requests = current_user.all_friends_requests + current_user.all_inverse_friends_requests
    @waits = current_user.all_friends_waits + current_user.all_inverse_friends_waits
  end
  
  def loadEvent
    last_event = Event.find(params[:last_event])
    
    friends = current_user.all_friends + current_user.all_inverse_friends
    friends_id = Array.new
    #friends_id << current_user.id
    friends.each do |friend|
      friends_id << friend.id
    end
    
    
    begin
      @events = Event.find(:all, :conditions => [ "user_id IN (?) and id != ? and created_at > ?", friends_id, last_event.id, last_event.created_at], :order => "created_at DESC")
    rescue ActiveRecord::RecordNotFound
      @events = []
    end
    
    respond_to do |format|
      format.json  { render :json => @events }
      format.html {}
    end

  end 

end
