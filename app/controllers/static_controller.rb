class StaticController < ApplicationController

	def home
	end

	def forecast

	# move this noise into a helper
		base_url = "https://api.darksky.net/forecast"
		key = ENV["DARK_SKY"]
		latitude = params[:lat]
		longitude = params[:lng]
		
		response = HTTParty.get("#{base_url}/#{key}/#{latitude},#{longitude}")
		p "*"*50
		p response
		respond_to do |format|
			format.json { render json: response }
			# format.html { 
			# 	flash[:info] = 'Please enable Javascript'
			# 	redirect_to 'static#home' }
		end

	end

end
