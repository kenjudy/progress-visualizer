require 'net/http'
require 'open-uri'
require 'json'

module Adapters
  class TrelloAdapter
    
    @credentials = {key: Trello::Constants::USER_KEY, token: Trello::Constants::READONLY_TOKEN}
    
    # def self.daily_burnup
    #   card_json = request_cards(Trello::Constants::CURRENT_SPRINT_BOARD_ID)
    #   Trello::Board.new(card_json)
    # end
    
    def self.request_board(board_id, include_archived = false)
      lists_data = request_lists(board_id)
      cards_data = request_cards(board_id)
      cards_data += request_archived_cards(board_id) if include_archived
      Trello::Board.new({cards: cards_data, lists: lists_data})
    end
    
    def self.request_archived_cards(board_id)
      request_json(Trello::Constants::TRELLO_EXPORT_ARCHIVED_CARDS_PATH, {board_id: board_id})
    end
    
    def self.request_cards(board_id)
      request_json(Trello::Constants::TRELLO_EXPORT_CARDS_PATH, {board_id: board_id})
    end
    
    def self.request_lists(board_id)
      request_json(Trello::Constants::TRELLO_BOARD_LISTS_PATH, {board_id: board_id})
    end
    
    private
    
    def self.request_json(url_template, options)
      url = "#{Trello::Constants::TRELLO_API_ROOT_URL}#{url_template}"
      options.merge(@credentials).each { |key,value| url.gsub!("<#{key.to_s.upcase}>", value) }
      return JSON.parse(URI.parse(url).read)
    end
  end
end