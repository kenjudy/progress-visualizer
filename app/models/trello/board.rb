require 'json'
require 'csv'

module Trello
  class Board < TrelloObject
  
    attr_reader :cards, :title
    
    def assign_attributes(data)
      @cards = []
      @data.each { |card| @cards << Card.new(card) }
      
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
  end
end