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
    
    friendship = user.friendships.build(:friend_id => friend_id, :request => current_user.id)
    if friendship.save
      redirect_to friends_path, :notice => "Sent friend request."
    else
      redirect_to friends_path, :notice => "Unable to send friend request."
      #render :action => 'new'
    end
  end
  
  def edit
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
    friendship = user.friendships.find_by_friend_id(friend_id)
    
    respond_to do |format|
      if friendship.update_attributes(:request => nil)
        format.html { redirect_to friends_path, :notice => "Accepted friend." }
        format.json { head :no_content }
      else
        format.html { redirect_to friends_path, :notice => "Could not accept friend." }
        format.json { render json: friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
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
    friendship = user.friendships.find_by_friend_id(friend_id)
    friendship.destroy
    
    respond_to do |format|
      format.html { redirect_to friends_path, :notice => "Removed friend." }
      format.json { head :no_content }
    end
  end
end
