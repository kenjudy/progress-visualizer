class UsersController < ApplicationController
  include Authentication
  
  before_filter :user_authenticate, only: [:create, :create_submit]
  
  def logout
    session.delete(:user)
    render "application/alert", locals: { type: "info", message: "You are logged out. See you soon..."}
  end
  
  def forgot_password
    user = User.find_by(name: params[:name])
    binding.pry
    if user
      random_password = user.reset_password
      user.save!
      UserMailer.forgot_password(user, random_password).deliver
    end
    render_user_action(user, "A new password for <em>{user.name}</em> e-mailed to address on file.")
  end
      
  def delete
    user = User.find_by(name: params[:name])
    user.destroy if user
    render_user_action(user, "User <em>{user.name}</em> has been deleted.")
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
  
  private 
  
  def render_user_action(user, message)
    if user
      render "application/alert", locals: { type: "info", message: message.gsub("{user.name}", user.name) }
    else
      render "application/alert", status: "500", locals: { type: "danger", message: "<strong>Failure</strong>, the requested user cannot be found."} 
    end
  end
end
