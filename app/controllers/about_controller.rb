class AboutController < ApplicationController
  include UserProfileConcern

  before_filter :assign_user_profile

  def index
  end

  def terms_and_conditions
  end

  def privacy_policy
  end

end
