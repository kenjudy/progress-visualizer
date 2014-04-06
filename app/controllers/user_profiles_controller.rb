class UserProfilesController < ApplicationController
  include UserProfileConcern

  before_filter :authenticate_user!
  before_filter :assign_user_profile, only: [:index, :show, :edit, :update]

  def index
    @profiles = current_user.user_profiles
  end

  def show
    @profiles = current_user.user_profiles
    @profile = current_user.user_profiles.find(params[:id])
    respond_to do |format|
      format.html { render }
      format.json { render json: @profile.to_json(only: UserProfile.array_attributes.map{|attrib_name| attrib_name.to_sym},
                                                  methods: [:readonly_token, :current_sprint_board_id, :current_sprint_board_id_short, :backlog_lists, :done_lists],
                                                  include: [:done_stories, :burn_ups]) }
      format.csv  { render text: @profile.to_csv }
    end
  end

  def new
    @profile = UserProfile.new(user: current_user)
    @profile.default = "1" if current_user.user_profiles.length == 0
  end

  def edit
    @profile ||= current_user.user_profiles.find(params[:id])
    alert = "User profile doesn't exist!" unless @profile
    @profile.current_sprint_board_id = get_current_sprint_board_id
    @lists = get_lists
    @labels = get_labels
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
    @lists = get_lists
    @labels = get_labels
    list_keys(params)
    if (update_profile(@profile, profile_params).valid?)
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

  def update_profile(profile, profile_params)
    profile.update_attributes(profile_params)
    profile.save
    return profile
  end

  def start_date(params)
    month = params["user_profile"].delete("start_date(2i)")
    day   = params["user_profile"].delete("start_date(3i)")
    year  = params["user_profile"].delete("start_date(1i)")
    if params["user_profile"]["duration"].to_i > 7 && month && day && year
      params["user_profile"]["start_date"] =  Time.local(year, month, day)
    end
  end

  def add_webhook(user_profile, callback_url)
    begin
      BaseAdapter.build_adapter(user_profile).add_webhook(callback_url, user_profile.current_sprint_board_id) unless Webhook.find_by(user_profile: user_profile, callback_url: callback_url)
    rescue JSON::ParserError => e
      logger.error(e.message)
    rescue Net::ReadTimeout => e
      logger.error(e.message)
   end
  end

  def destroy_webhook(user_profile, callback_url)
    adapter = BaseAdapter.build_adapter(user_profile)
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

  def get_lists
    Rails.cache.fetch("#{Rails.env}::UserProfilesController.lists.#{@profile.current_sprint_board_id_short}", expires_in: 10.minutes) do
       BaseAdapter.build_adapter(@profile).request_lists(@profile.current_sprint_board_id_short)
    end
  end
  
  def list_keys(params)
    params["user_profile"]["backlog_lists"] = keys_from_values(@lists, params["user_profile"]["backlog_lists"])
    params["user_profile"]["done_lists"] = keys_from_values(@lists, params["user_profile"]["done_lists"])
  end

  def get_current_sprint_board_id
    meta = Rails.cache.fetch("#{Rails.env}::UserProfilesController.board_meta.#{@profile.current_sprint_board_id_short}", expires_in: 10.minutes) do
      BaseAdapter.build_adapter(@profile).request_board_metadata(@profile.current_sprint_board_id_short)
    end
    meta["id"]
  end
  
  def get_labels
    meta = Rails.cache.fetch("#{Rails.env}::UserProfilesController.board_meta.#{@profile.current_sprint_board_id_short}", expires_in: 10.minutes) do
      BaseAdapter.build_adapter(@profile).request_board_metadata(@profile.current_sprint_board_id_short)
    end
    meta["labelNames"].map { |k,v| v.empty? ? [k,k] : [k,v] }
  end
end