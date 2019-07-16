class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:phone]
  has_many :driver_courses, class_name: 'Course', foreign_key: :driver_id
  has_many :client_courses, class_name: 'Course', foreign_key: :client_id

  validates :phone, presence: :true, uniqueness: { case_sensitive: false }
  validates :phone, format: { with: /((\+|00)212|0)\s*[1-9](?:[\s.-]*\d{2}){4}/ }

  # To remove email from sign_up requirements (overriding devise)
  def email_required?
   false
  end
end
