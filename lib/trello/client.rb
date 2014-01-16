require 'net/http'
require 'open-uri'
require 'json'

module Trello
  class Client
    
    @credentials = {key: TrelloReport::Constants::USER_KEY, token: TrelloReport::Constants::READONLY_TOKEN}
    
    def self.request_archived_cards(board_id)
      JSON.parse(URI.parse(archived_cards_url(board_id)).read)
    end
    
    def self.archived_cards_url(board_id)
      generate_url(TrelloReport::Constants::TRELLO_EXPORT_ARCHIVED_CARDS_PATH, {board_id: board_id}.merge(@credentials))
    end
    
    def self.generate_url(url_template, options)
      url = "#{TrelloReport::Constants::TRELLO_API_ROOT_URL}#{url_template}"
      options.each { |key,value| url.gsub!("<#{key.to_s.upcase}>", value) }
      return url
    end
  end
end