class ReportsController < ApplicationController
  include UserProfileConcern
  include ChartsConcern

  before_filter :authenticate_user!, :assign_user_profile, except: :sharing

  def performance_summary
    if params["iteration"]
      @iteration = params["iteration"]
      summary_for_iteration(user_profile, @iteration)
    else
      @iteration = user_profile.beginning_of_current_iteration.strftime("%Y-%m-%d")
      @collated_results = Factories::DoneStoryFactory.new(user_profile).current
      yesterdays_weather_action(user_profile, 3)
      long_term_trend_action(user_profile, 10)
    end
    @prior_iteration = user_profile.prior_iteration(@iteration)
    @next_iteration = user_profile.next_iteration(@iteration)
  end
  
  def sharing
    share = ReportSharing.find_by(guid: params["guid"])
    if share.expiration <= Time.now
      render :file => "#{Rails.root}/public/410.html", :status => 410
      return
    end
    
    matches = /\/report\/([\w-]+)\/?(\d{4}-\d{2}-\d{2})?/.match(share.url)
    action = matches[1].gsub("-", "_")
    @iteration = matches[2] || share.user_profile.beginning_of_iteration(share.created_at).strftime("%Y-%m-%d")
    summary_for_iteration(share.user_profile, @iteration)
    #render view without layout
    render text: "hello"
  end
  
  private
  
  def summary_for_iteration(user_profile, iteration)
    @collated_results = Factories::DoneStoryFactory.new(user_profile).for_iteration(iteration)
    yesterdays_weather_action(user_profile, 3, iteration)
    long_term_trend_action(user_profile, 10, iteration)
  end
end

