class FriendshipsController < ApplicationController
  
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
    
    #friend should build relationship with requestee if id is less
    @friendship = user.friendships.build(:friend_id => friend_id, :initiator => current_user.id)
    
    if @friendship.save
      flash[:notice] = "Added friend."
      redirect_to root_url
    else
      flash[:error] = "Unable to add friend."
      redirect_to root_url
    end
  end
  
  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_to current_user
  end
end