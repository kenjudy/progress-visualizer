class ChartsController < ApplicationController
  include Charts::ChartsPresenter
  
  def burn_up
    data = Charts::BurnUpChart.current_burn_up_data
        
    @estimates_chart = burn_up_chart_visualization({label: "Estimates", data:  data.map{ |burn_up| { timestamp: burn_up.timestamp, backlog: burn_up.backlog_estimates, done: burn_up.done_estimates} }})

    @stories_chart = burn_up_chart_visualization({label: "Story Counts", data:  data.map{ |burn_up| { timestamp: burn_up.timestamp, backlog: burn_up.backlog, done: burn_up.done} }})
  end
  
  def yesterdays_weather
    weeks = params[:weeks] ? params[:weeks].to_i : 3
    @yesterdays_weather_chart_estimate_chart = yesterdays_weather_visualization({label: :estimate, weeks: weeks})
    @yesterdays_weather_chart_stories_chart = yesterdays_weather_visualization({label: :stories, weeks: weeks})
  end
  
  def long_term_trend
    weeks = params[:weeks] ? params[:weeks].to_i : 10
    @long_term_trend_chart = long_term_trend_visualization(weeks)
  end
  
end
