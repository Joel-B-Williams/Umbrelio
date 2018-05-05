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
			response = @forecast.get_current_forecast(latitude, longitude)

			@forecast.build_full_response(@forecast.assemble_past_forecasts(latitude, longitude), response)

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