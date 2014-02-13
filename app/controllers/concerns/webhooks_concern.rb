module WebhooksConcern
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers
    
  def add_webhook
    uri = Rails.application.config.adapter.generate_uri(Rails.application.config.trello[:webhooks_root_url] + Rails.application.config.trello[:add_webhooks_path])
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Post.new(uri)
      request.body = webhook_args
      http.request(request)
    end
    Rails.logger.info("-- RESPONSE TO #{uri.to_s}\n\n" << response.body)
    return response
  end
  
  def webhook_args
    <<-BODY
    {
      description: "ken.judy progress visualizer burnup",
      callbackURL: "#{webhooks_burn_up_url(format: 'json')}",
      idModel: #{Rails.application.config.current_sprint_board[:id]},
    }
    BODY
    end
  
end