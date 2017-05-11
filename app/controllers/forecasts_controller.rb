class ForecastsController < ApplicationController

	def new
		@forecast = Forecast.new
	end

	def create
		latitude = params[:lat]
		longitude = params[:lng]

		@user = current_user
		@forecast = Forecast.new(forecast_params)
		@forecast.location = @forecast.find_address(latitude, longitude)
		@forecast.user_id = current_user.id

		if @forecast.save
			# build into array and adjust add_past_week_to to iterate?
			current_forecast = @forecast.get_current_forecast(latitude, longitude)
			one_day_ago = @forecast.get_past_forecast(1, latitude, longitude)
			two_days_ago = @forecast.get_past_forecast(2, latitude, longitude)
			three_days_ago = @forecast.get_past_forecast(3, latitude, longitude)
			four_days_ago = @forecast.get_past_forecast(4, latitude, longitude)
			five_days_ago = @forecast.get_past_forecast(5, latitude, longitude)
			six_days_ago = @forecast.get_past_forecast(6, latitude, longitude)
			seven_days_ago = @forecast.get_past_forecast(7, latitude, longitude)
			
			response = current_forecast
			
			@forecast.add_past_week_to(response, one_day_ago, two_days_ago, three_days_ago, four_days_ago, five_days_ago, six_days_ago, seven_days_ago)

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
