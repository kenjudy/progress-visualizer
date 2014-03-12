class ReportsController < ApplicationController
  include IterationConcern
  include UserProfileConcern
  include Charts::ChartsConcern

  before_filter :authenticate_user!, :assign_user_profile
  
  def performance_summary
    @iteration = params["iteration"]

    @results = @iteration ? Factories::DoneStoryFactory.new(user_profile).for_iteration(@iteration) : Factories::DoneStoryFactory.new(user_profile).current
    
    yesterdays_weather_action

    long_term_trend_action
  end
end
  
