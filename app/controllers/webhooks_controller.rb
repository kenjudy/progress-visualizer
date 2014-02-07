class WebhooksController < ApplicationController
  
  def burn_up_add
    response = add_webhook
    render json: response.body
  end
  
  def burn_up_delete
    delete_webhook
    render text: "OK"
  end
  
  def burn_up
    logger.info("-- WEBHOOK #{request.body}")
    Charts::BurnUpChart.current(Adapters::TrelloAdapter).update
    render text: "OK"
  end
  
  def delete_webhook
    #https://trello.com/1/webhooks/[WEBHOOK_ID]?key=[APPLICATION_KEY]&token=[USER_TOKEN]
  end
  
  
end
