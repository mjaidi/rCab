class Course < ApplicationRecord
  belongs_to :client, class_name: "User", foreign_key: :client_id
  belongs_to :driver, class_name: "User", foreign_key: :driver_id, optional: :true

  STATUS = ['pending', 'search', 'accepted', 'arrived', 'finished', 'rated', 'canceled']
  validates :status, presence: true
  validates :status, inclusion: {in: STATUS}

  before_save :geocode_endpoints
  validates_presence_of :start_address, :end_address


  private

  def geocode_endpoints
    if start_address_changed?
      geocoded = Geocoder.search(start_address).first
      if geocoded
        self.start_lat = geocoded.latitude
        self.start_lon = geocoded.longitude
        setTimeDuration
      end
    end
    if end_address_changed?
      geocoded = Geocoder.search(end_address).first
      if geocoded
        self.end_lat = geocoded.latitude
        self.end_lon = geocoded.longitude
        setTimeDuration
      end
    end
  end
end

def calculate_price
  (self.duration * 0.1 + self.distance*0.2).round(2)
end

def setTimeDuration
  url = "https://api.mapbox.com/directions/v5/mapbox/driving-traffic?access_token=#{ENV['MAPBOX_API_KEY']}"
  conn = Faraday.new(:url => url) do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to $stdout
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end


  response = conn.post('', {coordinates: "#{self.start_lon},#{self.start_lat};#{self.end_lon},#{self.end_lat}"})
  if response.status == 200
    self.distance = JSON.parse(response.body)['routes'][0]['distance']/1000
    self.duration = JSON.parse(response.body)['routes'][0]['duration']/60
    self.price = calculate_price
  else
    errors.add(:base, 'Invalid address')
  end
end
