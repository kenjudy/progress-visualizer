require 'net/http'
require 'open-uri'
require 'json'

module Adapters
  class TrelloAdapter
    
    @credentials = {key: Constants::TRELLO[:app_key], token: Constants::TRELLO[:readonly_token]}
    
    def self.current_sprint_board_properties
      Constants::CONFIG[:current_sprint_board]
    end
        
    def self.request_board(board_id, include_archived = false)
      ProgressVisualizerTrello::Board.new(request_board_data(board_id, include_archived))
    end
    
    def self.request_archived_cards(board_id)
      request_archived_cards_data(board_id).map{ |d| ProgressVisualizerTrello::Card.new(d) }
    end
    
    def self.request_cards(board_id)
      request_cards_data(board_id).map{ |d| ProgressVisualizerTrello::Card.new(d) }
    end
    
    def self.request_lists(board_id)
      request_lists_data(board_id).map{ |d| ProgressVisualizerTrello::List.new(d) }
    end

    def self.request_board_data(board_id, include_archived = false)
      lists_data = request_lists_data(board_id)
      cards_data = request_cards_data(board_id)
      cards_data += request_archived_cards_data(board_id) if include_archived
      {cards: cards_data, lists: lists_data}
    end
    
    def self.request_archived_cards_data(board_id)
      request_json(Constants::TRELLO[:export_archived_cards_path], {board_id: board_id})
    end
    
    def self.request_cards_data(board_id)
      request_json(Constants::TRELLO[:export_cards_path], {board_id: board_id})
    end
    
    def self.request_lists_data(board_id)
      request_json(Constants::TRELLO[:board_lists_path], {board_id: board_id})
    end
    
    def self.request_user_token_url
      generate_url_string(Constants::TRELLO[:trello_root_url] << Constants::TRELLO[:request_token_path])
    end
    
    def self.generate_uri(url_template, options = {})
      URI.parse(generate_url_string(url_template, options))
    end

    private
    
    def self.generate_url_string(url_template, options = {})
      options.merge(@credentials).each { |key,value| url_template.gsub!("<#{key.to_s.upcase}>", value) }
      url_template
    end
    
    def self.request_json(url_template, options)
      return JSON.parse(generate_uri("#{Constants::TRELLO[:api_root_url]}#{url_template}", options).read)
    end
  end
end