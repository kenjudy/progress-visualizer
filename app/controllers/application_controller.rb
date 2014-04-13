class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_filter :set_timezone 
  before_filter :configure_devise_params, if: :devise_controller?
 
  protected


  def json_request?
    request.format.json?
  end
  
  def set_timezone  
    Time.zone = current_user.time_zone if current_user
  end  
  
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :current_password, :password, :password_confirmation, :time_zone)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :current_password, :password, :password_confirmation, :time_zone)
    end
  end
  
end
