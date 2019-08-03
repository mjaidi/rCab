class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string, unique: true
    add_column :users, :verified_whatsapp, :boolean
    add_column :users, :admin, :boolean
    add_column :users, :driver, :boolean
    add_column :users, :photo_moto, :string
    add_column :users, :photo_cin, :string
    add_column :users, :photo, :string
  end
end
