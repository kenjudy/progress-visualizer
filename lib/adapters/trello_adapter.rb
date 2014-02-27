require 'net/http'
require 'open-uri'
require 'json'

module Adapters
  class TrelloAdapter < BaseAdapter
    
    def initialize(user_profile)
      super
      @credentials = {key: Rails.application.config.trello[:app_key], token: user_profile.readonly_token }
    end
        
    def request_board(board_id, include_archived = false)
      ProgressVisualizerTrello::Board.new(request_board_data(board_id, include_archived))
    end
    
    def request_archived_cards(board_id)
      request_all_cards_data(board_id).map{ |d| ProgressVisualizerTrello::Card.new(d) }
    end
    
    def request_cards(board_id)
      request_cards_data(board_id).map{ |d| ProgressVisualizerTrello::Card.new(d) }
    end
    
    def request_lists(board_id)
      request_lists_data(board_id).map{ |d| ProgressVisualizerTrello::List.new(d) }
    end

    def request_board_data(board_id, include_archived = false)
      lists_data = request_lists_data(board_id)
      cards_data = include_archived ? request_all_cards_data(board_id) : request_cards_data(board_id)
      {cards: cards_data, lists: lists_data}
    end
    
    def request_board_metadata(board_id)
      get_json(Rails.application.config.trello[:board_meta_path], {board_id: board_id})
    end
    
    def request_all_cards_data(board_id)
      get_json(Rails.application.config.trello[:export_all_cards_path], {board_id: board_id})
    end
    
    def request_cards_data(board_id)
      get_json(Rails.application.config.trello[:export_cards_path], {board_id: board_id})
    end
    
    def request_lists_data(board_id)
      get_json(Rails.application.config.trello[:board_lists_path], {board_id: board_id})
    end
    
    def user_token_url
      generate_uri(Rails.application.config.trello[:trello_root_url] + Rails.application.config.trello[:request_token_path]).to_s
    end
    
    def add_webhook(callback_url, id_model)
      params = {"description" => "#{user_profile.user.name} #{user_profile.name} burnup", "callbackURL" => callback_url, "idModel" => id_model, }
      response = post_json(Rails.application.config.trello[:add_webhooks_path], params)
      webhook_attr = JSON.parse(response.body)
      Webhook.create(user_profile: user_profile, external_id: webhook_attr["id"], description: webhook_attr["description"], id_model: webhook_attr["idModel"], callback_url: webhook_attr["callbackURL"] )
    end

    def destroy_webhook(webhook)
      delete(Rails.application.config.trello[:manage_webhooks_path], {webhook_id: webhook.external_id})
    end
    
    private
    
    def generate_uri(url_template, options = {})
      url = url_template
      options.merge(@credentials).each { |key,value| url.gsub!("<#{key.to_s.upcase}>", value || "") }
      return parse_url_string(url)
    end
    
    def parse_url_string(url_string)
      URI.parse(url_string)
    end
    
    def get_json(url_template, options)
      return JSON.parse(generate_uri("#{Rails.application.config.trello[:api_root_url]}#{url_template}", options).read)
    end
    
    def post_json(url_template, params, options = {})
      uri = generate_uri("#{Rails.application.config.trello[:trello_root_url]}#{url_template}", options)
      request = Net::HTTP::Post.new(uri.path+"?"+uri.query)
      request.add_field('Content-Type', 'application/json')
      request.body = params.to_json
      http_request(uri, request)
    end
    
    def delete(url_template, options)
      uri = generate_uri("#{Rails.application.config.trello[:trello_root_url]}#{url_template}", options)
      request = Net::HTTP::Delete.new(uri.path+"?"+uri.query)
      http_request(uri, request)
    end

    def http_request(uri, request)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.request(request)
    end
  end
end