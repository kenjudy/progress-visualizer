class TablesController < ApplicationController
  include UserProfileConcern
  include IterationConcern

  before_filter :authenticate_user!, :assign_user_profile
  
  def done_stories
    @results = Tables::DoneStoriesTable.new(user_profile).current
  end
  
end
