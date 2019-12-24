class AddLocationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_lat, :float
    add_column :users, :last_lng, :float
    add_column :users, :last_location_update, :datetime
  end
end
