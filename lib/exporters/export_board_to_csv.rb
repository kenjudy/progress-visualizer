require 'net/http'
require 'open-uri'
require 'json'
require 'csv'

module Exporters
  class ExportBoardToCsv
    def self.export_current_sprint_board(target_file)
      run(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID, target_file)
    end
  
    def self.run(board_id, target_file)
      json = request_json(board_id)
      board = Trello::Board.new(json)
      CSV.open(target_file, "wb") do |csv|
        csv << Trello::Card.array_attributes
        board.to_array.each { |arr| csv << arr }
      end
    end

    def self.form_request_url(board_id)
      "#{TrelloReport::Constants::TRELLO_API_ROOT_URL}#{TrelloReport::Constants::TRELLO_EXPORT_CARDS_PATH}".gsub("<BOARD_ID>", board_id).gsub("<KEY>", TrelloReport::Constants::USER_KEY).gsub("<TOKEN>", TrelloReport::Constants::READONLY_TOKEN)
    end

    def self.request_json(board_id)
      JSON.parse(URI.parse(form_request_url(board_id)).read)
    end
  end
end
