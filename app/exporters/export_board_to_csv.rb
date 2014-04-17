require 'csv'

class ExportBoardToCsv
  def self.export_current_sprint_board(user_profile, target_file)
    board = Board.find_by(user_profile: user_profile)
    CSV.open(target_file, "ab") do |csv|
      csv << Card.array_attributes
      board.to_array.each { |arr| csv << arr }
    end
  end

end
