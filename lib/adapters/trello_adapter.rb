require 'net/http'
require 'open-uri'
require 'json'

module Adapters
  class TrelloAdapter
    
    def initialize()
      @credentials = {key: Rails.application.config.trello[:app_key], token: Rails.application.config.trello[:readonly_token]}
    end
    
    def current_sprint_board_properties
      Rails.application.config.current_sprint_board
    end
        
    def request_board(board_id, include_archived = false)
      ProgressVisualizerTrello::Board.new(request_board_data(board_id, include_archived))
    end
    
    def request_archived_cards(board_id)
      request_archived_cards_data(board_id).map{ |d| ProgressVisualizerTrello::Card.new(d) }
    end
    
    def request_cards(board_id)
      request_cards_data(board_id).map{ |d| ProgressVisualizerTrello::Card.new(d) }
    end
    
    def request_lists(board_id)
      request_lists_data(board_id).map{ |d| ProgressVisualizerTrello::List.new(d) }
    end

    def request_board_data(board_id, include_archived = false)
      lists_data = request_lists_data(board_id)
      cards_data = request_cards_data(board_id)
      cards_data += request_archived_cards_data(board_id) if include_archived
      {cards: cards_data, lists: lists_data}
    end
    
    def request_board_metadata(board_id)
      request_json(Rails.application.config.trello[:board_meta_path], {board_id: board_id})
    end
    
    def request_archived_cards_data(board_id)
      request_json(Rails.application.config.trello[:export_archived_cards_path], {board_id: board_id})
    end
    
    def request_cards_data(board_id)
      request_json(Rails.application.config.trello[:export_cards_path], {board_id: board_id})
    end
    
    def request_lists_data(board_id)
      request_json(Rails.application.config.trello[:board_lists_path], {board_id: board_id})
    end
    
    def request_user_token_url
      generate_url_string(Rails.application.config.trello[:trello_root_url] << Rails.application.config.trello[:request_token_path])
    end
    
    def generate_uri(url_template, options = {})
      URI.parse(generate_url_string(url_template, options))
    end

    private
    
    def generate_url_string(url_template, options = {})
      options.merge(@credentials).each { |key,value| url_template.gsub!("<#{key.to_s.upcase}>", value) }
      url_template
    end
    
    def request_json(url_template, options)
      return JSON.parse(generate_uri("#{Rails.application.config.trello[:api_root_url]}#{url_template}", options).read)
    end
  end
end