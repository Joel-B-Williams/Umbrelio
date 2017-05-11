class ForecastsController < ApplicationController

	def new
		@forecast = Forecast.new
	end

	def create
		p "*"*50
		p params
		@user = current_user
		@forecast = Forecast.new
		# @forecast = Forecast.create(forecast_params)
		# redirect_to user_path(@user)

		base_url = "https://api.darksky.net/forecast"
		key = ENV["DARK_SKY"]
		latitude = params[:lat]
		longitude = params[:lng]
		api_url = "#{base_url}/#{key}/#{latitude},#{longitude}"

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

		p "*"*50
		p response

		# respond_to do |format|
		# 	format.json { render json: response }
		# end
		render :json => response
	end

	private
		def forecast_params
			params.permit(:lat, :lng, :id)
		end
end
