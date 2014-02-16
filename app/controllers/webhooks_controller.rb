class WebhooksController < ApplicationController
  include IterationConcern
    
  def burn_up
    Charts::BurnUpChart.current(UserProfile.find(params["profile_id"])).update
    render text: "OK"
  end
  
  def delete_webhook
    #https://trello.com/1/webhooks/[WEBHOOK_ID]?key=[APPLICATION_KEY]&token=[USER_TOKEN]
  end
  
  
end
