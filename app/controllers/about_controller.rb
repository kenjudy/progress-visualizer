class AboutController < ApplicationController
  include UserProfileConcern

  before_filter :assign_user_profile

  def index
  end

  def terms_and_conditions
  end

  def privacy_policy
  end
  
  def release_notes
    @lists = Rails.cache.fetch("ProgressVisualizerReleaseNotes", :expires_in => 5.minutes) do
      Adapters::TrelloAdapter.release_notes
    end
  end

end
