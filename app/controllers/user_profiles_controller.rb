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
  end
  
  def edit
    @profile = current_user.user_profiles.find(params[:id])
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
    current_user.user_profiles.find(params[:id]).destroy
  end
  
end