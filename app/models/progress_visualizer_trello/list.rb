require 'json'

module ProgressVisualizerTrello
  class List < TrelloObject

    attr_reader :id, :name, :id_board

    def assign_attributes(data)
      @id = @data["id"]
      @name = @data["name"]
      @id_board = @data["idBoard"]
    end

    def self.lists_for_profile(profile, board_id = nil)
      board_id ||= profile.current_sprint_board_id_short
      BaseAdapter.build_adapter(profile).request_lists(board_id)
    end

  end

end