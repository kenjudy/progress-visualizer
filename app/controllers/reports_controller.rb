class ReportsController < ApplicationController
  include Authentication
  include Charts::ChartsPresenter
  
  before_filter :user_authenticate
  
  def performance_summary
    @results = Tables::DoneStoriesTable.current
    
    estimate_chart = Charts::YesterdaysWeatherChart.new({weeks: 4, label: :estimate})
    @yesterdays_weather_chart_estimate_chart = yesterdays_weather_visualization(estimate_chart, true)
    
    stories_chart = Charts::YesterdaysWeatherChart.new({weeks: 4, label: :stories})
    @yesterdays_weather_chart_stories_chart = yesterdays_weather_visualization(stories_chart, true)

    @long_term_trend_chart = long_term_trend_visualization(10, true)
  end
  
end
  
