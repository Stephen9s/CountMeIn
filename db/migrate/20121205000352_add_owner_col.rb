class AddOwnerCol < ActiveRecord::Migration
  def change
    add_column :memberships, :owner_id, :integer
  end
end
