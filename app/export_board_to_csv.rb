require 'net/http'
require 'open-uri'
require 'json'
require 'csv'

require_relative '../app/constants'
require_relative '../app/board'


module TrelloReport
  include Constants

  class ExportBoardToCsv
    def self.export_current_sprint_board(target_file)
      run(@@current_sprint_board_id, target_file)
    end
    
    def self.run(board_id, target_file)
      json = request_json(board_id)
      board = Board.new(json)

      CSV.open(target_file, "wb") do |csv|
        csv << Card.array_attributes
        board.to_array.each { |arr| csv << arr }
      end
    end

    def self.form_request_url(board_id)
      "#{@@trello_api_root_url}#{@@trello_export_cards_path}".gsub("<BOARD_ID>", board_id).gsub("<KEY>", @@user_key).gsub("<TOKEN>", @@readonly_token)
    end

    def self.request_json(board_id)
      JSON.parse(URI.parse(form_request_url(board_id)).read)
    end

  end
end
