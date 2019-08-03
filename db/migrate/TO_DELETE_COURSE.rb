class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.datetime :date
      t.string :start_address
      t.string :end_address
      t.integer :price
      t.integer :client_id
      t.integer :driver_id
      t.integer :note_course
      t.integer :note_driver
      t.text :comment_course
      t.string :course_status

      t.timestamps
    end
  end
end
