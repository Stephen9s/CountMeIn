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
  end

  def profile
    @profile = User.find(session[:user_id], :select => "username, email, f_name, l_name, mobile_phone, dob, gender, description, email", :limit => 1)
  end

  def setting
  end
  
  def friend
    @friends = User.find(@current_user.all_friends, :select => 'id, username, f_name, l_name')
    @requests = User.find(@current_user.all_friends_requests, :select => 'id, username, f_name, l_name')
    @waits = User.find(@current_user.all_friends_waits, :select => 'id, username, f_name, l_name')
    @search_list = nil
    if !params[:search].nil? and params[:search].size > 0
      @search_list = User.find(:all, :select => 'id, username, f_name, l_name', :conditions => ['f_name || l_name || username LIKE ? and id != ?', "%#{params[:search.downcase]}%", @current_user.id])
      @search_list = @search_list - @friends - @requests - @waits
    end
  end
  
end
