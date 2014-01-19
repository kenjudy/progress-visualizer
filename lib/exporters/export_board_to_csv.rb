require 'csv'

module Exporters
  class ExportBoardToCsv
    def self.export_current_sprint_board(target_file)
      run(Trello::Constants::CURRENT_SPRINT_BOARD_ID, target_file)
    end
  
    def self.run(board_id, target_file)
      json = Adapters::TrelloAdapter.request_archived_cards(board_id)
      board = Trello::Board.new(json)
      CSV.open(target_file, "wb") do |csv|
        csv << Trello::Card.array_attributes
        board.to_array.each { |arr| csv << arr }
      end
    end

  end
end
