class WebhooksController < ApplicationController
  include UserProfileConcern
  include IterationConcern
    
  def index
    render text: "TODO"
  end
  
  def show
    render text: "TODO"
  end
  
  def new
    render text: "TODO"
  end 
  
  def edit
    render text: "TODO"
  end
  
  def create
    render text: "TODO"
  end
  
  def update
    render text: "TODO"
  end
  
  def destroy
    render text: "TODO"
  end
  
  def burn_up
    Charts::BurnUpChart.new(UserProfile.find(params["profile_id"])).update
    render text: "OK"
  end
  
  def delete_webhook
    #https://trello.com/1/webhooks/[WEBHOOK_ID]?key=[APPLICATION_KEY]&token=[USER_TOKEN]
  end
  
  private
  
  
  # def add_webhook
  #   uri = Rails.application.config.adapter.generate_uri(Rails.application.config.trello[:webhooks_root_url] + Rails.application.config.trello[:add_webhooks_path])
  #   response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
  #     request = Net::HTTP::Post.new(uri)
  #     request.body = webhook_args
  #     http.request(request)
  #   end
  #   Rails.logger.info("-- RESPONSE TO #{uri.to_s}\n\n" << response.body)
  #   return response
  # end
  # 
  # def webhook_args
  #   <<-BODY
  #   {
  #     description: "ken.judy progress visualizer burnup",
  #     callbackURL: "#{webhooks_burn_up_url(format: 'json')}",
  #     idModel: #{Rails.application.config.current_sprint_board[:id]},
  #   }
  #   BODY
  #   end
  
  
end
