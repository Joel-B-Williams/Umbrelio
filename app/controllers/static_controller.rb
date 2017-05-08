class StaticController < ApplicationController

	def home
	end

	def forecast

	# move this noise into a helper
		base_url = "https://api.darksky.net/forecast"
		key = ENV["DARK_SKY"]
		latitude = params[:lat]
		longitude = params[:lng]
		api_url = "#{base_url}/#{key}/#{latitude},#{longitude}"
		current = HTTParty.get(api_url)
		past = HTTParty.get(api_url+",2017-05-08T12:00:00")
		p"*"*80 
		response = current.parsed_response
		past = past.parsed_response
		response["past"] = past
		p response
		p"*"*80 
		
		p response["past"]["daily"]#.daily.data.temperatureMax
		# response = current
		respond_to do |format|
			format.json { render json: response }
			# format.html { 
			# 	flash[:info] = 'Please enable Javascript'
			# 	redirect_to 'static#home' }
		end

	end

end
