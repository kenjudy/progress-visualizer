require 'json'

module ProgressVisualizerTrello
  class List < TrelloObject

    attr_reader :id, :name, :id_board

    def assign_attributes(data)
      @id = @data["id"]
      @name = @data["name"]
      @id_board = @data["idBoard"]
    end
  end

end