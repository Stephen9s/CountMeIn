class CreateFriendships < ActiveRecord::Migration
  def up
    create_table :friendships do |f|
      f.integer :user_id
      f.integer :friend_id
      f.integer :initiator
      f.timestamps
    end
  end

  def down
  end
end
