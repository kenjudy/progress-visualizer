class ChartsController < ApplicationController
  include ChartVisualizations
  
  def daily_burnup
    data = Charts::DailyBurnup.current_burnup_data
        
    @estimates_chart = burnup_chart_visualization({label: "Estimates", data:  data.map{ |burnup| { timestamp: burnup.timestamp, backlog: burnup.backlog_estimates, done: burnup.done_estimates} }})

    @stories_chart = burnup_chart_visualization({label: "Story Counts", data:  data.map{ |burnup| { timestamp: burnup.timestamp, backlog: burnup.backlog, done: burnup.done} }})
  end
  
  def yesterdays_weather
    @yesterdays_weather_chart_estimate_chart = yesterdays_weather_visualization(:estimate)
    @yesterdays_weather_chart_stories_chart = yesterdays_weather_visualization(:stories)
  end
  
  def long_term_trend
    @long_term_trend_chart = long_term_trend_visualization
  end
  
end
