class UserMailer < ActionMailer::Base
  default from: Constants::EMAIL[:default_from]
  
  def forgot_password(user, random_password)
    @user = user
    @random_password = random_password
    mail to: user.email, subject: "Password Recovery Request"
  end
  
end