class FriendshipsController < ApplicationController
  
  before_filter :authenticate_user, :except => [:index, :login, :login_attempt, :logout]
  before_filter :save_login_state, :only => [:index, :login, :login_attempt]
  
  def create
    #@friendship = Friendship.new(params[:friendship])
    @friendship = @current_user.friendships.build(:friend_id => params[:friend_id], :request => session[:user_id])
    if @friendship.save
      redirect_to friend_path, :notice => "Sent friend request."
    else
      redirect_to friend_path, :notice => "Unable to send a request."
      #render :action => 'new'
    end
  end
  
  def edit
    @friendship = Friendship.find(:all, 
      :conditions => ['(user_id = ? and friend_id = ?) or (user_id = ? and friend_id = ?)', 
                      params[:friend_id], @current_user.id, @current_user.id, params[:friend_id]]).first
    respond_to do |format|
      if @friendship.update_attributes(:request => 0)
        format.html { redirect_to friend_path, :notice => "Except friend." }
        format.json { head :no_content }
      else
        format.html { redirect_to friend_path, :notice => "Cannot except friend." }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    #@friendship = Friendship.find(params[:id])
    @friendship = Friendship.find(:all, 
      :conditions => ['(user_id = ? and friend_id = ?) or (user_id = ? and friend_id = ?)', 
                      params[:friend_id], @current_user.id, @current_user.id, params[:friend_id]]).first
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_to friend_path, :notice => "Removed friend." }
      format.json { head :no_content }
    end
  end
end
