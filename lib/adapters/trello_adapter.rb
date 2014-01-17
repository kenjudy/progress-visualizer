require 'net/http'
require 'open-uri'
require 'json'

module Adapters
  class TrelloAdapter
    
    @credentials = {key: TrelloReport::Constants::USER_KEY, token: TrelloReport::Constants::READONLY_TOKEN}
    
    def self.daily_burnup
      card_json = request_cards(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID)
      Trello::Board.new(card_json)
    end
    
    def self.request_archived_cards(board_id)
      request_json(TrelloReport::Constants::TRELLO_EXPORT_ARCHIVED_CARDS_PATH, {board_id: board_id})
    end
    
    def self.request_cards(board_id)
      request_json(TrelloReport::Constants::TRELLO_EXPORT_CARDS_PATH, {board_id: board_id})
    end
    
    private
    
    def self.request_json(url_template, options)
      url = "#{TrelloReport::Constants::TRELLO_API_ROOT_URL}#{url_template}"
      options.merge(@credentials).each { |key,value| url.gsub!("<#{key.to_s.upcase}>", value) }
      return JSON.parse(URI.parse(url).read)
    end
  end
end