class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string, unique: true
    add_column :users, :verified_whatsapp, :boolean, null: false, default: false
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :driver, :boolean, null: false, default: false
    add_column :users, :photo_moto, :string
    add_column :users, :photo_cin, :string
    add_column :users, :photo, :string
  end
end
