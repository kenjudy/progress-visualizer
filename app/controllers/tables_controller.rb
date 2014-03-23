class TablesController < ApplicationController
  include UserProfileConcern

  before_filter :authenticate_user!, :assign_user_profile

  def done_stories
    factory = Factories::DoneStoryFactory.new(user_profile)
    if params["iteration"]
      @iteration = params["iteration"]
      @collated_results = factory.for_iteration(@iteration)
    else
      @iteration = user_profile.beginning_of_current_iteration.strftime("%Y-%m-%d")
      @collated_results = factory.current
    end
    @prior_iteration = user_profile.prior_iteration(@iteration)
    @next_iteration = user_profile.next_iteration(@iteration)
    
    respond_to do |format|
      format.html { render }
      format.csv { render text: factory.to_csv(@collated_results) }
      format.json { render json: @collated_results.to_json }
    end
    
  end

  def todo_stories
    factory = Factories::TodoStoryFactory.new(user_profile)
    @collated_results = factory.current
    
    respond_to do |format|
      format.html { render }
      format.csv { render text: factory.to_csv(@collated_results) }
      format.json { render json: @collated_results.to_json }
    end
    
  end

end
