require 'uri'
class Course < ApplicationRecord
  NOTES = [1,1.5,2,2.5,3,3.5,4,4.5,5]

  belongs_to :client, class_name: "User", foreign_key: :client_id
  belongs_to :driver, class_name: "User", foreign_key: :driver_id, optional: :true

  STATUS = ['pending', 'search', 'accepted', 'arrived', 'finished', 'rated', 'canceled']
  validates :status, presence: true
  validates :status, inclusion: {in: STATUS}

  before_create :set_time_duration
  validates_presence_of :start_address, :end_address


  private

  def calculate_price
    (self.duration * 0.1 + self.distance*0.2).round(2)
  end

  # def geocode_endpoints
  #   if start_address_changed?
  #     # geocoded = Geocoder.search(start_address).first
  #     # if geocoded
  #     geocoded = search_address(start_address)
  #       self.start_lat = geocoded[:lat]
  #       self.start_lon = geocoded[:lng]
  #       set_time_duration unless (self.end_lat.nil? || self.end_lon.nil?)
  #     # end
  #   end
  #   if end_address_changed?
  #     # geocoded = Geocoder.search(end_address).first
  #     # if geocoded
  #     geocoded = search_address(end_address)
  #       self.end_lat = geocoded[:lat]
  #       self.end_lon = geocoded[:lng]
  #       set_time_duration unless (self.start_lat.nil? || self.start_lon.nil?)
  #     # end
  #   end
  # end

  # def search_address(address)
  #   url = "https://api.mapbox.com/geocoding/v5/mapbox.places/#{URI::encode(address)}.json?limit=1&access_token=#{ENV['MAPBOX_API_KEY']}"
  #   conn = Faraday.new(:url => url) do |faraday|
  #     faraday.request  :url_encoded             # form-encode POST params
  #     faraday.response :logger                  # log requests to $stdout
  #     faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  #   end

  #   response = conn.get()
  #   if response.status == 200
  #     return {lat: JSON.parse(response.body)['features'][0]['center'][1], lng: JSON.parse(response.body)['features'][0]['center'][0] }
  #   else
  #     errors.add(:base, 'Invalid address')
  #   end
  # end

  def set_time_duration
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
end
