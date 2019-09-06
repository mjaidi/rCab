class AddVerifyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :verified, :boolean, default: false
    add_column :users, :country_code, :string
  end
end
