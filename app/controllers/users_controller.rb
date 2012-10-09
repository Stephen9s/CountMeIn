class UsersController < ApplicationController
  
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
    if params[:search]
      @results = User.find(:all, :conditions => ['username LIKE ?', "%#{params[:search]}%"])
    else
      @results = []
    end
  end
  
end
