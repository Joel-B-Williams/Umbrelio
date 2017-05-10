class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.create(user_params)
		if @user.save
			# flash[:success] = "Welcome cadet."
			login(@user)
			redirect_to user_path(@user)
		else
			# flash.now[:danger] = "Errors detected.  Activating Orbital Railguns."
			render 'new'
		end
	end

	def show

	end

	private
		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end

		def login(user)
			session[:user_id] = user.id
		end

end
