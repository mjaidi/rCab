class Course < ApplicationRecord
  belongs_to :client, class_name: "User", foreign_key: :client_id
  belongs_to :driver, class_name: "User", foreign_key: :driver_id
end
