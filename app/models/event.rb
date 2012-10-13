class Event < ActiveRecord::Base
  
  
  
  attr_accessible :name, :location, :start_date, :end_date, :public, :user_id
  belongs_to :user
end
