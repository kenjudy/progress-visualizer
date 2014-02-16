class UserProfilesController < ApplicationController
  include IterationConcern

  before_filter :authenticate_user!
  before_filter :assign_user_profile, only: [:index, :show, :edit, :update]

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
    @profile = current_user.user_profiles.find(params[:id])
    lists
    params["user_profile"]["backlog_lists"] = keys_from_values(@lists, params["user_profile"]["backlog_lists"])
    params["user_profile"]["done_lists"] = keys_from_values(@lists, params["user_profile"]["done_lists"])
    @profile.update_attributes(profile_params)
    @profile.save
    if (@profile.valid?)
      redirect_to user_profiles_path
    else
      render 'edit'
    end
  end
  
  def destroy
    current_user.user_profiles.find(params[:id]).destroy
  end
  
  def set
    session[:user_profile] = params[:profile_id]
    assign_user_profile
    redirect_to request.referer
  end
  
  def keys_from_values(lists, values = "")
    result = {}
    list_matches = values.split(",").map{ |value| lists.select{|list| value == list.name } }.flatten.compact
    list_matches.map{ |list| result[list.id] = list.name } if list_matches.any?
    result.to_json
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
    allowed_attribs = [:name, :default, :readonly_token, :current_sprint_board_id_short, :current_sprint_board_id, :backlog_lists, :done_lists, :labels_types_of_work, :duration, :start_day_of_week, :start_hour, :end_day_of_week, :end_hour]
    params.require(:user_profile).permit(allowed_attribs)
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
       meta["labelNames"].map { |k,v| v.empty? ? [k,k] : [k,v] }
    end
  end
end