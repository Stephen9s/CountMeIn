class Message < ActiveRecord::Base
  
  attr_accessible :sender_id, :receiver_id, :subject, :body
  
  def mark_as_read()
    update_attribute('read', 1)
  end
  
  def mark_as_unread()
    update_attribute('read', 0)
  end
end
