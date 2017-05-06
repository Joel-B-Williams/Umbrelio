class StaticController < ApplicationController

	def home
	end

	def forecast

		# move this noise into a helper
		# require 'net/http'
		# require 'uri'

	
			# render nothing: true
			base_url = "https://api.darksky.net/forecast"
			key = ENV["DARK_SKY"]
			latitude = params[:lat]
			longitude = params[:lng]
			# uri = URI.parse("#{base_url}/#{key}/#{latitude},#{longitude}")
			# Net::HTTP.get_print(uri) 
			response = HTTParty.get("#{base_url}/#{key}/#{latitude},#{longitude}")
			respond_to do |format|
				format.json { render json: response }
				format.html { redirect_to 'static#home' }
			end
	
			# NO RESPONSE BEING SENT TO JS
		
	
	end

end
