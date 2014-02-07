module WebhooksConcern
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers
    
  def add_webhook
    uri = Constants::CONFIG[:default_adapter].generate_uri(Constants::TRELLO[:webhooks_root_url] + Constants::TRELLO[:add_webhooks_path])
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
      idModel: #{Constants::CONFIG[:current_sprint_board][:id]},
    }
    BODY
    end
  
end