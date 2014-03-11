class ChartsController < ApplicationController
  include Charts::ChartsConcern
  include UserProfileConcern
  include IterationConcern
  
  before_filter :authenticate_user!, :assign_user_profile
  
  def burn_up_reload
    render json: { last_update: Rails.cache.fetch(BurnUp.last_update_key(user_profile)) }.to_json
  end
  
  def burn_up
    @iteration = Date.parse(params["iteration"]) if params["iteration"]
    data = Factories::BurnUpFactory.new(user_profile).burn_up_data(@iteration)
    unless data.any?
      flash.now[:notice] = "No burn up data."
      flash.now[:notice] << " Next iteration starts at #{beginning_of_iteration(@iteration || Date.today).strftime('%b %e, %l %p')}." if between_iterations(@iteration || Date.today)
    end
    @estimates_chart = burn_up_chart_visualization({label: "Estimates", data:  data.map{ |burn_up| { timestamp: burn_up.timestamp, backlog: burn_up.backlog_estimates, done: burn_up.done_estimates} }})
    @uses_estimates = has_non_zero_values(@estimates_chart)
    @stories_chart = burn_up_chart_visualization({label: "Story Counts", data:  data.map{ |burn_up| { timestamp: burn_up.timestamp, backlog: burn_up.backlog, done: burn_up.done} }})
   end
  
  def yesterdays_weather
    yesterdays_weather_action
  end
  
  def long_term_trend
    long_term_trend_action
  end
  
  
  
end
