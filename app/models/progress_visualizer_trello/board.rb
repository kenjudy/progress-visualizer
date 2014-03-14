require 'json'
require 'csv'

module ProgressVisualizerTrello
  class Board < TrelloObject

    attr_reader :cards, :title, :lists

    def assign_attributes(data)
      @lists = create_child_objects(@data[:lists], List)
      @cards = create_child_objects(@data[:cards], Card)
      set_lists(@cards, @lists)
      @title = "Current Sprint" #TODO: board attributes
    end

    def to_array
      cards.map(&:to_array)
    end

    def to_csv
      CSV.generate do |csv|
        csv << Card.array_attributes
        self.to_array.each { |card| csv << card }
      end
    end

    private

    def set_lists(cards, lists)
      cards.each { |card| card.list = lists.find { |list| list.id == card.id_list }}
    end

    def create_child_objects(child_data_arr, klass)
      arr = []
      child_data_arr.each { |obj| arr << klass.send(:new, obj) }
      return arr
    end
  end
end