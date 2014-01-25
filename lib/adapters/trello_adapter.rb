require 'net/http'
require 'open-uri'
require 'json'

module Adapters
  class TrelloAdapter
    
    @credentials = {key: Trello::Constants::USER_KEY, token: Trello::Constants::READONLY_TOKEN}
    
    def self.daily_burnup
      board = request_board(Trello::Constants::CURRENT_SPRINT_BOARD_ID)
      Charts::DailyBurnup.new(board, { done_list_ids: Trello::Constants::CURRENT_SPRINT_BOARD_DONE_LIST_IDS,
                                       backlog_list_ids: Trello::Constants::CURRENT_SPRINT_BOARD_BACKLOG_LIST_IDS,
                                       timestamp: Time.now})
    end
    
    def self.request_board(board_id, include_archived = false)
      Trello::Board.new(request_board_data(board_id, include_archived))
    end
    
    def self.request_archived_cards(board_id)
      request_archived_cards_data(board_id).map{ |d| Trello::Card.new(d) }
    end
    
    def self.request_cards(board_id)
      request_cards_data(board_id).map{ |d| Trello::Card.new(d) }
    end
    
    def self.request_lists(board_id)
      request_lists_data(board_id).map{ |d| Trello::List.new(d) }
    end

    def self.request_board_data(board_id, include_archived = false)
      lists_data = request_lists_data(board_id)
      cards_data = request_cards_data(board_id)
      cards_data += request_archived_cards_data(board_id) if include_archived
      {cards: cards_data, lists: lists_data}
    end
    
    def self.request_archived_cards_data(board_id)
      request_json(Trello::Constants::TRELLO_EXPORT_ARCHIVED_CARDS_PATH, {board_id: board_id})
    end
    
    def self.request_cards_data(board_id)
      request_json(Trello::Constants::TRELLO_EXPORT_CARDS_PATH, {board_id: board_id})
    end
    
    def self.request_lists_data(board_id)
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