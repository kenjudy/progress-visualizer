class UserProfilesController < ApplicationController
  include IterationConcern

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
    @profile ||= current_user.user_profiles.find(params[:id])
    alert = "User profile doesn't exist!" unless @profile
    lists
    labels
    render 'edit', alert: alert
  end
  
  def create
    profile = UserProfile.new(user: current_user)
    profile.update_attributes(profile_params)
    profile.reload
    make_sole_default_if_is_default(profile)
    redirect_to edit_user_profile_path(profile.id)
  end
  
  def update
    #lists
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
  
  private
  
  def make_sole_default_if_is_default(current_profile)
    return unless current_profile.default == "1"
    current_user.user_profiles.each do |p|
      if p.default && p != current_profile
        p.default = "0"
        p.save
      end
    end
  end
  
  def profile_params
    params.require(:user_profile).permit(:user, :name, :default, :readonly_token, :current_sprint_board_id_short)
  end
  
  # 
  def lists
    @lists = Rails.cache.fetch("#{Rails.env}::UserProfilesController.lists.#{@profile.current_sprint_board_id_short}", :expires_in => 10.minutes) do
       adapter.request_lists(@profile.current_sprint_board_id_short)
    end
  end
  def labels
    @labels = Rails.cache.fetch("#{Rails.env}::UserProfilesController.labels.#{@profile.current_sprint_board_id_short}", :expires_in => 10.minutes) do
       meta = adapter.request_board_metadata(@profile.current_sprint_board_id_short)
       meta["labelNames"].values
    end
  end
end