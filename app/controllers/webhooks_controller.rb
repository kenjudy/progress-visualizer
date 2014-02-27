class WebhooksController < ApplicationController
  include UserProfileConcern
  include IterationConcern
  
  def burn_up
    Charts::BurnUpChart.new(UserProfile.find(params["profile_id"])).update
    render text: "OK"
  end
end
