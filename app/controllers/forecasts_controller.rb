class ForecastsController < ApplicationController

	def new
		@forecast = Forecast.new
	end

# terribly horribly fat controller - move to helper
	def create
		@user = current_user
		@forecast = Forecast.new(forecast_params)
		# @forecast = Forecast.create(forecast_params)
		# redirect_to user_path(@user)

		base_url = "https://api.darksky.net/forecast"
		dark_sky_key = ENV["DARK_SKY"]
		latitude = params[:lat]
		longitude = params[:lng]
		api_url = "#{base_url}/#{dark_sky_key}/#{latitude},#{longitude}"

		location_url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='
		google_key = ENV["GOOGLE_MAPS"]
		location = HTTParty.get(location_url+latitude+','+longitude+'&key='+google_key).parsed_response
		
		address = location["results"][0]["formatted_address"]
		
		@forecast.location = address

		@forecast.user_id = current_user.id

		if @forecast.save
			current = HTTParty.get(api_url).parsed_response
			one_day_ago = HTTParty.get(api_url+format_time(Time.now - 1.day)).parsed_response
			two_days_ago = HTTParty.get(api_url+format_time(Time.now - 2.days)).parsed_response
			three_days_ago = HTTParty.get(api_url+format_time(Time.now - 3.days)).parsed_response
			four_days_ago = HTTParty.get(api_url+format_time(Time.now - 4.days)).parsed_response
			five_days_ago = HTTParty.get(api_url+format_time(Time.now - 5.days)).parsed_response
			six_days_ago = HTTParty.get(api_url+format_time(Time.now - 6.days)).parsed_response
			seven_days_ago = HTTParty.get(api_url+format_time(Time.now - 7.days)).parsed_response
			
			 
			response = current
		
			response["one_day_ago"] = one_day_ago["daily"]["data"][0]
			response["two_days_ago"] = two_days_ago["daily"]["data"][0]
			response["three_days_ago"] = three_days_ago["daily"]["data"][0]
			response["four_days_ago"] = four_days_ago["daily"]["data"][0]
			response["five_days_ago"] = five_days_ago["daily"]["data"][0]
			response["six_days_ago"] = six_days_ago["daily"]["data"][0]
			response["seven_days_ago"] = seven_days_ago["daily"]["data"][0]

			# respond_to do |format|
			# 	format.json { render json: response }
			# end
			render :json => response
		else
			redirect_to user_path(@user)
		end
	end

	def index
		@user = current_user
		@recent_searches = @user.forecasts.order(created_at: :desc).limit(10)
	end

	private
		def forecast_params
			params.permit(:lat, :lng)
		end
end
