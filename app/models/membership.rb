class Membership < ActiveRecord::Base
  # Attributes to access
  attr_accessible :event_id, :user_id
  
  # For many memberships
  belongs_to :event
  validates :event_id, :presence => true, :uniqueness => {:scope => :user_id}
end
