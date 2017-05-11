module SessionsHelper

  def login_required
  	if !logged_in?
  		redirect_to login_path
  	end
  end

  def logged_in?
  	!!current_user
  end

  def current_user
  	if session[:user_id]
  		@current_user = User.find_by_id(session[:user_id])
  		@current_user
  	else
  		false
  	end
  end

end
