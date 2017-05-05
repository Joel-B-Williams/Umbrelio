class StaticController < ApplicationController

	def home
	end

	def forecast

		# move this noise into a helper
		require 'net/http'
		require 'uri'


		redirect_to 'static#home'
	end

end
