class WebhooksController < ApplicationController

  def burn_up
    begin
      Factories::BurnUpFactory.new(UserProfile.find(params["profile_id"])).update
      render text: "OK"
    rescue ActiveRecord::RecordNotFound
      render text: "Gone", status: "410"
    end
  end
end
