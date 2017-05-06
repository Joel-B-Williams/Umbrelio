class StaticController < ApplicationController

	def home
	end

	def forecast

		# move this noise into a helper
		# require 'net/http'
		# require 'uri'

		if request.xhr?
			render nothing: true
			base_url = "https://api.darksky.net/forecast"
			key = ENV["DARK_SKY"]
			latitude = params[:lat]
			longitude = params[:lng]
			# uri = URI.parse("#{base_url}/#{key}/#{latitude},#{longitude}")
			# Net::HTTP.get_print(uri) 
			@response = HTTParty.get("#{base_url}/#{key}/#{latitude},#{longitude}")
			p"*"*50
			p @response
			p"*"*50
			p @response.parsed_response
			"response"
			# NO RESPONSE BEING SENT TO JS
		else
			redirect_to 'static#home'
		end
	end

end
