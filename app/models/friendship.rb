class Friendship < ActiveRecord::Base
  attr_accessible :user_id, :friend_id, :request
  
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  validates :user_id, :presence => true, :uniqueness => {:scope => :friend_id}
  validates_numericality_of :user_id, :less_than => :friend_id
end
