class AddCoordinatesToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :start_lat, :float
    add_column :courses, :start_lon, :float
    add_column :courses, :end_lat, :float
    add_column :courses, :end_lon, :float
  end
end
