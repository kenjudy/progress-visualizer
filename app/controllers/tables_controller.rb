class TablesController < ApplicationController
  include UserProfileConcern
  include IterationConcern
  include TablesConcern

  before_filter :authenticate_user!, :assign_user_profile

  def done_stories
    if params["iteration"]
      @iteration = params["iteration"]
      @results = Factories::DoneStoryFactory.new(user_profile).for_iteration(@iteration)
    else
      @iteration = beginning_of_current_iteration.strftime("%Y-%m-%d")
      @results = Factories::DoneStoryFactory.new(user_profile).current
    end
    @prior_iteration = prior_iteration(@iteration)
    @next_iteration = next_iteration(@iteration)
  end

  def todo_stories
    @results = Factories::TodoStoryFactory.new(user_profile).current
  end

end
