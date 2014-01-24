require 'csv'

module Exporters
  class ExportBoardToCsv
    def self.export_current_sprint_board(target_file)
      run(Trello::Constants::CURRENT_SPRINT_BOARD_ID, target_file)
    end
  
    def self.run(board_id, target_file)
      board = Adapters::TrelloAdapter.request_board(board_id)
      CSV.open(target_file, "ab") do |csv|
        csv << Trello::Card.array_attributes
        board.to_array.each { |arr| csv << arr }
      end
    end

  end
end
