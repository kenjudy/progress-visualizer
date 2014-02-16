class HomepageController < ApplicationController
  include UserProfileConcern
  
  before_filter :assign_user_profile  

  def index
  end
  
end
