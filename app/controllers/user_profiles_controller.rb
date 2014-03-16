class UserProfilesController < ApplicationController
  include UserProfileConcern
  include IterationConcern

  before_filter :authenticate_user!
  before_filter :assign_user_profile, only: [:index, :show, :edit, :update]

  def index
    @profiles = current_user.user_profiles
  end

  def show
    @profiles = current_user.user_profiles
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
    start_date(params)
    lists
    labels
    params["user_profile"]["backlog_lists"] = keys_from_values(@lists, params["user_profile"]["backlog_lists"])
    params["user_profile"]["done_lists"] = keys_from_values(@lists, params["user_profile"]["done_lists"])
    if (update_profile(user_profile, profile_params).valid?)
      add_webhook(@profile, webhooks_burn_up_url(profile_id: @profile.id, format: :json))
      redirect_to user_profiles_path
    else
      render 'edit'
    end
  end

  def destroy
    profile = current_user.user_profiles.find(params[:id])
    destroy_webhook(profile, webhooks_burn_up_url(profile_id: profile.id, format: :json))
    profile.destroy
  end

  def set
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
  
  def update_profile(user_profile, profile_params)
    user_profile.update_attributes(profile_params)
    user_profile.save
    return user_profile
  end

  def start_date(params)
    month = params["user_profile"].delete("start_date(2i)")
    day   = params["user_profile"].delete("start_date(3i)")
    year  = params["user_profile"].delete("start_date(1i)")
    params["user_profile"]["start_date"] = params["user_profile"]["duration"] > "7" && month && day && year ? Time.local(year, month, day) : nil
  end

  def add_webhook(user_profile, callback_url)
    begin
      Adapters::BaseAdapter.build_adapter(user_profile).add_webhook(callback_url, user_profile.current_sprint_board_id) unless Webhook.find_by(user_profile: user_profile, callback_url: callback_url)
    rescue JSON::ParserError => e
     logger.error(e.message)
   end
  end

  def destroy_webhook(user_profile, callback_url)
    adapter = Adapters::BaseAdapter.build_adapter(user_profile)
    Webhook.where("user_profile_id = ?", user_profile.id).each do |webhook|
      adapter.destroy_webhook(webhook)
    end
  end

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
    allowed_attribs = [:name, :default, :readonly_token, :current_sprint_board_id_short, :current_sprint_board_id, :backlog_lists, :done_lists, :labels_types_of_work, :duration, :start_day_of_week, :start_hour, :end_day_of_week, :end_hour, :start_date]
    params.require(:user_profile).permit(allowed_attribs)
  end

  #
  def lists
    @lists = Rails.cache.fetch("#{Rails.env}::UserProfilesController.lists.#{@profile.current_sprint_board_id_short}", :expires_in => 10.minutes) do
       Adapters::BaseAdapter.build_adapter(@profile).request_lists(@profile.current_sprint_board_id_short)
    end
  end
  def labels
    @labels = Rails.cache.fetch("#{Rails.env}::UserProfilesController.labels.#{@profile.current_sprint_board_id_short}", :expires_in => 10.minutes) do
       meta = Adapters::BaseAdapter.build_adapter(@profile).request_board_metadata(@profile.current_sprint_board_id_short)
       meta["labelNames"].map { |k,v| v.empty? ? [k,k] : [k,v] }
    end
  end
end