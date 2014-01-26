class ChartsController < ApplicationController
  include ChartVisualizations
  
  def daily_burnup
    data = Charts::DailyBurnup.current_burnup_data
        
    @estimates_chart = burnup_chart_visualization({label: "Estimates", data:  data.map{ |burnup| { timestamp: burnup.timestamp, backlog: burnup.backlog_estimates, done: burnup.done_estimates} }})

    @stories_chart = burnup_chart_visualization({label: "Story Counts", data:  data.map{ |burnup| { timestamp: burnup.timestamp, backlog: burnup.backlog, done: burnup.done} }})
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
