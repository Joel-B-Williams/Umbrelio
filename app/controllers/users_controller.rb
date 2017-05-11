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
			render 'new'
		end
	end

	def show
		@user = current_user
		@forecast = Forecast.new
		@recent_searches = @user.forecasts.order(created_at: :desc).limit(10)

	end

	private
		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end

		def login(user)
			session[:user_id] = user.id
		end

end
