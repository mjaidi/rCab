class AddColumnsToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :distance, :float
    add_column :courses, :duration, :float
  end
end
