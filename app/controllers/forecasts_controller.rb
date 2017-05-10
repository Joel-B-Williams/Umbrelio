class ForecastsController < ApplicationController

	def new
		@forecast = Forecast.new
	end

	def create
	end

end
