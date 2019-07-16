class Course < ApplicationRecord
  belongs_to :client_course, class_name: "User", foreign_key: :client_id
  belongs_to :driver_course, class_name: "User", foreign_key: :driver_id
end
