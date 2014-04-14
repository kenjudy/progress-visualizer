require 'csv'

class ExportBoardToCsv
  def self.export_current_sprint_board(user_profile, target_file)
    board = ProgressVisualizerTrello::Board.find_current_sprint_board(user_profile)
    CSV.open(target_file, "ab") do |csv|
      csv << ProgressVisualizerTrello::Card.array_attributes
      board.to_array.each { |arr| csv << arr }
    end
  end

end
