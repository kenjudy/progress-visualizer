class TablesController < ApplicationController
  include UserProfileConcern
  include IterationConcern

  before_filter :authenticate_user!, :assign_user_profile
  
  def done_stories
    @results = Factories::DoneStoryFactory.new(user_profile).current
  end
  
  def todo_stories
    @results = Factories::TodoStoryFactory.new(user_profile).current
  end
  
end
