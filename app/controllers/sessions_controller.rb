class SessionsController < ApplicationController
	# skip_before_action :login_required, :only => [:new, :create]

	def new
		@user = User.new
	end

	def create
		user = User.find_by_email(params[:sessions][:email])
		if user && user.authenticated?(params[:sessions][:password])
			login(user)
			redirect_to user_path(user)
		else
			flash.now[:info] = "Invalid email or password"
			render "new"
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end

	private
		
		def login(user)
			session[:user_id] = user.id
		end

end
