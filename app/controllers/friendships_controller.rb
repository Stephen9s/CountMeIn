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
    friend_id_r = friend_id
    
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
    
    # NEED TO DESTROY EACH OTHER'S MEMBERSHIPS WITHOUT DESTROY EVENT OWNER'S MEMBERSHIP
    
    # Find events owned by new_current_user_id, remove friend's memberships
    friends_memberships_with_me = Membership.find(:all, :conditions => ["owner_id = ? and user_id != ? and user_id = ?", current_user.id, current_user.id, friend_id_r])
    friends_memberships_with_me.each do |r|
      r.destroy
    end
    
    friends_memberships_with_them = Membership.find(:all, :conditions => ["owner_id = ? and user_id != ? and user_id = ?", friend_id_r, friend_id_r, current_user.id])
    friends_memberships_with_them.each do |r|
      r.destroy
    end

    
    respond_to do |format|
      format.html { redirect_to friends_path, :notice => "Removed friend and all memberships to events." }
      format.json { head :no_content }
    end
  end
end
