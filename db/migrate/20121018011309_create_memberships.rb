class CreateMemberships < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.integer :event_id
      t.integer :user_id
      t.timestamps
    end
  end

  def down
    drop_table :memberships
  end
end
