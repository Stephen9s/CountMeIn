class Event < ActiveRecord::Base
  attr_accessible :name, :location, :start_date, :end_date, :public, :user_id
  
  DAY_REGEX = /^\d{4}-(0\d|10|11|12)-([012]\d|30|31)$/
  
  
  validates :name, :presence => true
  validates :location, :presence => true
  validates :start_date, :presence => true, :format => DAY_REGEX
  validates :end_date, :presence => true, :format => DAY_REGEX
  validates :public, :presence => true
  validates :user_id, :presence => true
  attr_accessor :username
  belongs_to :user
  #default_scope :order => "start_date ASC"
  
  
  # Relationship logic
  has_many :memberships
  has_many :users, :through => :memberships
  
  
  before_destroy { |event| event.memberships.destroy_all }
end
