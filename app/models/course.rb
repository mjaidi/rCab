class Course < ApplicationRecord
  belongs_to :client, class_name: "User", foreign_key: :client_id
  belongs_to :driver, class_name: "User", foreign_key: :driver_id

  STATUS = ['search', 'accepted', 'arrived', 'finished', 'rated', 'canceled']
  validates :status, presence: true
  validates :status, inclusion: {in: STATUS}

  before_save :geocode_endpoints

  private

  def geocode_endpoints
    if start_address_changed?
      geocoded = Geocoder.search(start_address).first
      if geocoded
        self.start_lat = geocoded.latitude
        self.start_lon = geocoded.longitude
      end
    end
    if end_address_changed?
      geocoded = Geocoder.search(end_address).first
      if geocoded
        self.end_lat = geocoded.latitude
        self.end_lon = geocoded.longitude
      end
    end
  end
end
