class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include StaticControllerHelper
  include SessionsHelper
  include UsersHelper
  include ForecastsHelper
end
