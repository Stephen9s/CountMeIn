class FriendshipsController < ApplicationController
  
  before_filter :authenticate_user
  
  def create
    
    #friend_id = 1
    friend_id = params[:friend_id].to_i
    
    # if 2 > 1
    if current_user.id > friend_id
      # friend_id = 2
      friend_id = current_user.id
      
      # new_curr = 1
      new_current_user_id = current_user.id
      
      user = User.find(params[:friend_id])
    else
      user = current_user
    end
    
    #@friendship = Friendship.new(params[:friendship])
    @friendship = user.friendships.build(:friend_id => friend_id, :request => current_user.id)
    if @friendship.save
      redirect_to friends_path, :notice => "Sent friend request."
    else
      redirect_to friends_path, :notice => "Unable to send friend request."
      #render :action => 'new'
    end
  end
  
  def edit
    @friendship = Friendship.find(:all, 
      :conditions => ['(user_id = ? and friend_id = ?) or (user_id = ? and friend_id = ?)', 
                      params[:friend_id], @current_user.id, @current_user.id, params[:friend_id]]).first
    respond_to do |format|
      if @friendship.update_attributes(:request => 0)
        format.html { redirect_to friends_path, :notice => "Accept friend." }
        format.json { head :no_content }
      else
        format.html { redirect_to friends_path, :notice => "Cannot Accept friend." }
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
      format.html { redirect_to friends_path, :notice => "Removed friend." }
      format.json { head :no_content }
    end
  end
end
