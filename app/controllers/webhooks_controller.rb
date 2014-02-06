class WebhooksController < ApplicationController
  
  def burn_up_add
    response = add_webhook({
          description: "ken.judy burnup webhook",
          callbackURL: webhooks_burn_up_url(format: 'json'),
          idModel: Constants::CONFIG[:current_sprint_board][:id]
         })
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
  
  def add_webhook(args)
    #https://trello.com/docs/gettingstarted/webhooks.html
    uri = Constants::CONFIG[:default_adapter].generate_uri(Constants::TRELLO[:webhooks_root_url] + Constants::TRELLO[:add_webhooks_path])
    postData = Net::HTTP.post_form(uri, args)
    logger.info("-- RESPONSE TO #{uri.to_s}\n\n" << postData.body)
    return postData
  end
  
end
