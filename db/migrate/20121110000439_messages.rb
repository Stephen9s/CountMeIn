class Messages < ActiveRecord::Migration
  def up
    create_table :messages do |t|
      
      t.integer :sender_id
      t.integer :receiver_id
      t.string :subject
      t.string :body
      t.integer :read, :default => 0
      
      t.timestamps
    end
  end

  def down
    drop_table :messages
  end
end
