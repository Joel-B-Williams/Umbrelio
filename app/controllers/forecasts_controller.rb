class ForecastsController < ApplicationController

	def new
		@forecast = Forecast.new
	end

	def create
		latitude = params[:lat]
		longitude = params[:lng]
		@forecast = Forecast.new(forecast_params)
		@forecast.location = @forecast.find_address(latitude, longitude)
		if @forecast.save 
			response = @forecast.get_current_forecast(latitude, longitude)

			render :json => response
		else
			redirect_to root_path
			flash.now[:error]="Error 483: Something has gone pearshaped"
		end
	end

	private
		def forecast_params
			params.permit(:lat, :lng)
		end
	end