class Forecast < ApplicationRecord

	BASE_DARK_SKY_URL = "https://api.darksky.net/forecast"
	DARK_SKY_KEY = ENV["DARK_SKY"]
	LOCATION_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='
	GOOGLE_KEY = ENV["GOOGLE_MAPS"]

	def self.dark_sky_url(base_url, key, latitude, longitude)
		"#{base_url}/#{key}/#{latitude},#{longitude}"
	end

	def find_address(latitude, longitude)
		find_location(latitude, longitude)["results"][0]["formatted_address"]
	end

	def get_current_forecast(latitude, longitude)
		HTTParty.get(Forecast.dark_sky_url(BASE_DARK_SKY_URL, DARK_SKY_KEY, latitude, longitude))
	end

	private

		def find_location(latitude, longitude)
		  HTTParty.get(LOCATION_URL+latitude+','+longitude+'&key='+GOOGLE_KEY).parsed_response
		end

		def format_time(time)
			/(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})/.match(time.to_s)
			','+$1+"T"+$2
		end

end
