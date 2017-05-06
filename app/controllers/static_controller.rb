class StaticController < ApplicationController

	def home
	end

	def forecast

		# move this noise into a helper
		require 'net/http'
		require 'uri'

		if request.xhr?
			base_url = "https://api.darksky.net/forecast"
			key = ENV["DARK_SKY"]
			latitude = params[:lat]
			longitude = params[:lng]
			uri = URI.parse("#{base_url}/#{key}/#{latitude},#{longitude}")
			Net::HTTP.get_print(uri)
		end
	end

end
