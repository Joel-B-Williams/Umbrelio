class StaticController < ApplicationController

	def home
	end

	def forecast

		# move this noise into a helper
		require 'net/http'
		require 'uri'

		if request.xhr?
			p "*"*50
			p params
			# redirect_to 'static#home'
		end
	end

end
