class ReportsController < ApplicationController
  include IterationConcern
  include UserProfileConcern
  include ChartsConcern
  include TablesConcern

  before_filter :authenticate_user!, :assign_user_profile

  def performance_summary
    if params["iteration"]
      @iteration = params["iteration"]
      @results = Factories::DoneStoryFactory.new(user_profile).for_iteration(@iteration)
      yesterdays_weather_action(3, @iteration)
      long_term_trend_action(10, @iteration)
    else
      @iteration = beginning_of_current_iteration.strftime("%Y-%m-%d")
      @results = Factories::DoneStoryFactory.new(user_profile).current
      yesterdays_weather_action(3)
      long_term_trend_action(10)
    end

    @prior_iteration = prior_iteration(@iteration)
    @next_iteration = next_iteration(@iteration)
  end
end

