class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :start_address
      t.string :end_address
      t.float :price
      t.integer :client_id
      t.integer :driver_id, null: true
      # t.references :user, foreign_key: true
      t.integer :note
      t.text :comment
      t.string :status

      t.timestamps
    end
  end
end
