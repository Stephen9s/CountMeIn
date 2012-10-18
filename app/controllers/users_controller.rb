class UsersController < ApplicationController
  
  before_filter :authenticate_user, :except => [:new, :create]
  
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
    friends = current_user.all_friends + current_user.all_inverse_friends
    requests = current_user.all_friends_requests + current_user.all_inverse_friends_requests
    waits = current_user.all_friends_waits + current_user.all_inverse_friends_waits
    @search_list = nil
    if !params[:search].nil? and params[:search].size > 0
      @search_list = User.find(:all, :select => 'id, username, f_name, l_name', :conditions => ['f_name || l_name || username LIKE ? and id != ?', "%#{params[:search.downcase]}%", @current_user.id])
      @search_list = @search_list - friends - requests - waits
    end
  end
  
end
