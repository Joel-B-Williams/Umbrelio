class Forecast < ApplicationRecord
	belongs_to :user

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

	def get_past_forecast(days_ago, latitude, longitude)
		if days_ago == 1
			HTTParty.get(Forecast.dark_sky_url(BASE_DARK_SKY_URL, DARK_SKY_KEY, latitude, longitude)+format_time(Time.now - days_ago.day)).parsed_response
		else
			HTTParty.get(Forecast.dark_sky_url(BASE_DARK_SKY_URL, DARK_SKY_KEY, latitude, longitude)+format_time(Time.now - days_ago.days)).parsed_response
		end
	end

	# def add_past_week_to(response, one_day_ago, two_days_ago, three_days_ago, four_days_ago, five_days_ago, six_days_ago, seven_days_ago)
	# 		add_past_forecast_to(response, one_day_ago, "one_day_ago")
	# 		add_past_forecast_to(response, two_days_ago, "two_days_ago")
	# 		add_past_forecast_to(response, three_days_ago, "three_days_ago")
	# 		add_past_forecast_to(response, four_days_ago, "four_days_ago")
	# 		add_past_forecast_to(response, five_days_ago, "five_days_ago")
	# 		add_past_forecast_to(response, six_days_ago, "six_days_ago")
	# 		add_past_forecast_to(response, seven_days_ago, "seven_days_ago")
	# end

		def add_past_forecast_to(response, past_forecast, days_ago)
			response[days_ago] = past_forecast["daily"]["data"][0]
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
