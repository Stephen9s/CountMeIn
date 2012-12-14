class AddGoogleEventId < ActiveRecord::Migration
  def change
    add_column :memberships, :google_event_id, :string
  end
end
