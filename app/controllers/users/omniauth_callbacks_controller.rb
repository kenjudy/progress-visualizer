class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    auth = request.env["omniauth.auth"]
    @user = User.find_for_twitter_oauth(auth)

    omniauth("twitter", auth)
  end

  def trello
    auth = request.env["omniauth.auth"]
    @user = User.find_for_trello_oauth(auth)

    omniauth("trello", auth, "Note: If you're using Google to sign into Trello, use Google to sign in to Progress Visualizer.")
  end
  
  def google_oauth2
    auth = request.env["omniauth.auth"]
    @user = User.find_for_google_oauth2(auth)
    
    omniauth("google_oauth2", auth)
  end
  
  private
  
  def omniauth(provider, auth, additional_error_message = "")
    #prevent cookie overflow
    auth["extra"] = { "raw_info" => {} } if auth["extra"]["raw_info"]
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.titleize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = auth
      redirect_to new_user_registration_url
      set_flash_message(:error, :failure, kind: provider.titleize, reason: errors << additional_error_message) if is_navigational_format?
    end
  end
  
  def errors
    if @user.errors.full_messages.any?
      ":<ul>" << @user.errors.full_messages.map { |message| "<li>#{message}</li>" }.uniq.join("\n") << "</ul>"
    else
      " unable to save user. "
    end
  end
end