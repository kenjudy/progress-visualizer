class TablesController < ApplicationController
  include UserProfileConcern
  include IterationConcern

  before_filter :authenticate_user!, :assign_user_profile

  def done_stories
    factory = Factories::DoneStoryFactory.new(user_profile)
    if params["iteration"]
      @iteration = params["iteration"]
      @collated_results = factory.for_iteration(@iteration)
    else
      @iteration = beginning_of_current_iteration.strftime("%Y-%m-%d")
      @collated_results = factory.current
    end
    @prior_iteration = prior_iteration(@iteration)
    @next_iteration = next_iteration(@iteration)
    
    respond_to do |format|
      format.html { render }
      format.csv { render text: factory.to_csv(@collated_results) }
    end
    
  end

  def todo_stories
    factory = Factories::TodoStoryFactory.new(user_profile)
    @collated_results = factory.current
    
    respond_to do |format|
      format.html { render }
      format.csv { render text: factory.to_csv(@collated_results) }
    end
    
  end

end
