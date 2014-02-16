class ReportsController < ApplicationController
  include IterationConcern
  include Charts::ChartsPresenter

  before_filter :authenticate_user!, :assign_user_profile
  
  def performance_summary
    @results = Tables::DoneStoriesTable.new(user_profile).current
    
    estimate_chart = Charts::YesterdaysWeatherChart.new(user_profile, {weeks: 4, label: :estimate})
    @yesterdays_weather_estimate_chart = yesterdays_weather_visualization(estimate_chart, true)
    
    stories_chart = Charts::YesterdaysWeatherChart.new(user_profile, {weeks: 4, label: :stories})
    @yesterdays_weather_stories_chart = yesterdays_weather_visualization(stories_chart, true)

    @long_term_trend_chart = long_term_trend_visualization(10, true)
  end
end
  
