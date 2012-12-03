class ApplicationController < ActionController::Base
  protect_from_forgery  
  
  def sidebar
    if current_user
      friends = current_user.all_friends + current_user.all_inverse_friends
      online = User.where("last_seen > ?",10.minutes.ago.to_s())
      @online_friends = (friends & online)
    end
  end
  
  def update_last_seen
    if current_user
      current_user.last_seen = DateTime.now
      current_user.save
    else
      redirect_to(:controller => 'sessions', :action => 'logout')
    end
  end 
  
  
  protected
    
    def authenticate_user
      unless session[:user_id]
        redirect_to(:controller => 'sessions', :action => 'login')
        return false
      else
        begin
          @current_user = User.find(session[:user_id])
          self.update_last_seen
          self.sidebar
          return true
        rescue ActiveRecord::RecordNotFound
          redirect_to(:controller => 'sessions', :action => 'logout')
        end
      end
    end
    
    def save_login_state
      if session[:user_id]
        redirect_to(:controller => 'sessions', :action => 'home')
        return false
      else
        return true
      end
    end
    
    private
    
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    helper_method :current_user
end
