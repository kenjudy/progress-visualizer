class UserProfilesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @profiles = current_user.user_profiles
  end
  
  def show
    @profile = current_user.user_profiles.find(params[:id])
  end
  
  def new
    @profile = UserProfile.new(user: current_user)
    @profile.default = "1" if current_user.user_profiles.length == 0
  end
  
  def edit
    @profile = current_user.user_profiles.find(params[:id])
  end
  
  def create
    @profile = UserProfile.new(params[:user_profile])
  end
  
  def update
    @profile = current_user.user_profiles.find(params[:id])
    @profile.save
    if (@profile.valid?)
      render 'thank_you'
    else
      render 'edit'
    end
  end
  
  def destroy
    current_user.user_profiles.find(params[:id]).destroy
  end
  
end