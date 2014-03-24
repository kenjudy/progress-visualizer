class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    auth = env["omniauth.auth"]

    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"],current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.twitter_uid"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def trello
    @user = User.find_for_trello_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Trello") if is_navigational_format?
    else
      auth = request.env["omniauth.auth"]
      auth["extra"] = { "raw_info" => { "email" => auth["extra"]["raw_info"]["email"]} } if auth["extra"]["raw_info"]
      session["devise.trello_data"] = auth
      redirect_to new_user_registration_url
    end
  end
end