class Event < ActiveRecord::Base
  attr_accessible :name, :location, :start_date, :end_date, :public, :user_id
  belongs_to :user
  
  
  # Relationship logic
  has_many :memberships
  has_many :users, :through => :memberships
  
  
  before_destroy { |event| event.memberships.destroy_all }
end
