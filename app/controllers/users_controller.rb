class UsersController < ApplicationController
  
  before_filter :authenticate_user, :except => [:new, :create]
  before_filter :save_login_state, :only => [:new, :create]

  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = "Username successfull created!"
      flash[:color] = "valid"
      
      # if created, then don't ask them to create another one...
      # redirect to login
      redirect_to :controller => 'sessions', :action => 'login'
    else
      flash[:notice] = "Form is invalid"
      flash[:color] = "invalid"
      render "new"
    end
    
  end
  
  def search
    @friends = User.find(current_user.all_friends, :select => 'id, username, f_name, l_name')
    @requests = User.find(current_user.all_friends_requests, :select => 'id, username, f_name, l_name')
    @waits = User.find(current_user.all_friends_waits, :select => 'id, username, f_name, l_name')
    @search_list = nil
    if !params[:search].nil? and params[:search].size > 0
      @search_list = User.find(:all, :select => 'id, username, f_name, l_name', :conditions => ['f_name || l_name || username LIKE ? and id != ?', "%#{params[:search.downcase]}%", @current_user.id])
      @search_list = @search_list - @friends - @requests - @waits
    end
  end
  
  def friends
    @friends = User.find(current_user.all_friends, :select => 'id, username, f_name, l_name')
    @requests = User.find(current_user.all_friends_requests, :select => 'id, username, f_name, l_name')
    @waits = User.find(current_user.all_friends_waits, :select => 'id, username, f_name, l_name')
  end
  
  
  
end
