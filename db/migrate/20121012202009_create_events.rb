class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :location
      t.integer :user_id
      t.integer :public

      t.timestamps
    end
  end
end
