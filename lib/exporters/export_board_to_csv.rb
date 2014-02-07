require 'csv'

module Exporters
  class ExportBoardToCsv
    def self.export_current_sprint_board(target_file)
      run(Adapters::TrelloAdapter.current_sprint_board_properties[:id], target_file)
    end
  
    def self.run(board_id, target_file)
      board = Adapters::TrelloAdapter.request_board(board_id)
      CSV.open(target_file, "ab") do |csv|
        csv << ProgressVisualizerTrello::Card.array_attributes
        board.to_array.each { |arr| csv << arr }
      end
    end

  end
end
