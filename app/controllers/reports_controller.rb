require 'open-uri'

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
      render :file => "#{Rails.root}/public/410.html", status: 410
      return
    end
    
    matches = /\/report\/([\w-]+)\/?(\d{4}-\d{2}-\d{2})?/.match(share.url)
    action = matches[1].gsub("-", "_")
    @iteration = matches[2] || share.user_profile.beginning_of_iteration(share.created_at).strftime("%Y-%m-%d")
    summary_for_iteration(share.user_profile, @iteration)
    render "reports/performance_summary", layout: 'report_sharing'
  end
  
  def sharing_new
    action = params["report"].gsub("-", "_")

    iteration = params["iteration"] || user_profile.beginning_of_current_iteration.strftime("%Y-%m-%d")
    url = send("reports_#{action}_url", iteration)
    share = ReportSharing.create(user_profile: user_profile, expiration: Date.today + 1.month, url: url)
    flash[:notice] = sharing_notice(share)
    redirect_to send("reports_#{action}_path", iteration)
  end
  
  private
  
  def summary_for_iteration(user_profile, iteration)
    @collated_results = Factories::DoneStoryFactory.new(user_profile).for_iteration(iteration)
    yesterdays_weather_action(user_profile, 3, iteration)
    long_term_trend_action(user_profile, 10, iteration)
  end
  
  def shorten_url(url)
    begin
      api_request = Rails.application.config.bitly[:save_link_url].gsub("<TOKEN>", Rails.application.config.bitly[:token]) << CGI.escape(url)
      url = JSON.parse(URI.parse(api_request).read)["data"]["link_save"]["link"]
    rescue => e
      logger.error(e.message)
    end
    url
  end
  
  def sharing_notice(share)
    <<-HTML
    This report will be shareable until #{share.expiration.strftime("%B %e, %Y")} at: 
    <input type="text" readonly autofocus value="#{shorten_url(reports_sharing_url(share.guid))}" id="share-link"></input>
    HTML
  end
end

