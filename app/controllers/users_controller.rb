class UsersController < ApplicationController
  include Authentication
  
  before_filter :user_authenticate, only: [:create, :create_submit]
  
  def logout
    session.delete(:user)
    render "application/alert", locals: { type: "info", message: "You are logged out. See you soon..."}
  end
  
  def forgot_password
    user = get_user
    if user
      random_password = Array.new(10).map { (65 + rand(58)).chr }.join
      user.password = random_password
      user.save!
      #TODO: Mailer.create_and_deliver_password_change(@user, random_password)
      render "application/alert", locals: { type: "info", message: "A new password for <em>#{user.name}</em> e-mailed to address on file."}
    end
  end
      
  def delete
    user = get_user
    if user
      user.destroy
      render "application/alert", locals: { type: "info", message: "User <em>#{user.name}</em> has been deleted."}
    end
  end
  
  def create
    @user = User.new
  end
  
  def create_submit
    @user = User.find_or_initialize_by(name: params["user"]["name"], email: params["user"]["email"])
    @user.password = params["user"]["password"] 
    @user.save
    if @user.valid?
      render "application/alert", locals: { type: "info", message: "User <em>#{@user.name}</em> has been created."}
    else
      render "users/create"
    end
  end
  
  def get_user
    user = User.find_by(name: params[:name])
    render "application/alert", locals: { type: "danger", message: "<strong>Failure</strong>, the requested user cannot be found."} unless user
    return user
  end
end
