class ChartsController < ApplicationController
  include Charts::ChartsPresenter
  include UserProfileConcern
  include IterationConcern
  
  before_filter :authenticate_user!, :assign_user_profile
  
  def burn_up_reload
    render json: { last_update: Rails.cache.fetch(BurnUp.last_update_key) }.to_json
  end
  
  def burn_up
    @iteration = Date.parse(params["iteration"]) if params["iteration"]
    data = Charts::BurnUpChart.new(user_profile).burn_up_data(@iteration)
    @estimates_chart = burn_up_chart_visualization({label: "Estimates", data:  data.map{ |burn_up| { timestamp: burn_up.timestamp, backlog: burn_up.backlog_estimates, done: burn_up.done_estimates} }})

    @stories_chart = burn_up_chart_visualization({label: "Story Counts", data:  data.map{ |burn_up| { timestamp: burn_up.timestamp, backlog: burn_up.backlog, done: burn_up.done} }})
   end
  
  def yesterdays_weather
    estimate_chart = Charts::YesterdaysWeatherChart.new(user_profile, {weeks: params[:weeks] ? params[:weeks].to_i : 3, label: :estimate})
    @yesterdays_weather_estimate_chart = yesterdays_weather_visualization(estimate_chart)
    stories_chart = Charts::YesterdaysWeatherChart.new(user_profile, {weeks: params[:weeks] ? params[:weeks].to_i : 3, label: :stories})
    @yesterdays_weather_stories_chart = yesterdays_weather_visualization(stories_chart)
  end
  
  def long_term_trend
    weeks = params[:weeks] ? params[:weeks].to_i : 10
    @long_term_trend_chart = long_term_trend_visualization(weeks)
  end
  
end
