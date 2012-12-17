class Message < ActiveRecord::Base
  
  ALPHANUMSPACE_REGEX = /^[0-9A-Za-z ]+$/i
  
  attr_accessible :sender_id, :receiver_id, :subject, :body
  validates :receiver_id, :presence => true
  validates :subject, :presence => true, :format => ALPHANUMSPACE_REGEX
  validates :body, :presence => true, :format => ALPHANUMSPACE_REGEX
  
  def mark_as_read()
    update_attribute('read', 1)
  end
  
  def mark_as_unread()
    update_attribute('read', 0)
  end
end
