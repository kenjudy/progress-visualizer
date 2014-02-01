module Authentication
  extend ActiveSupport::Concern

  def user_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      valid = check_credentials(username, password)
      session[:user] = username if valid
      valid
    end
  end

  def check_credentials(username, password)
    @user = User.find_by(name: username)
    @user && @user.password == password
  end

end