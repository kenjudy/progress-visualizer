require 'json'
require 'csv'

require_relative 'trello_object'
require_relative 'card'

module TrelloReport
  class Board < TrelloReport::TrelloObject
  
    attr_reader :cards
    
    def initialize(json)
      super
      @cards = []
      @json.each { |card| @cards << Card.new(card) }
    end
    
    def to_array
      cards.map(&:to_array)
    end

    def to_csv
      CSV.generate do |csv|
        csv << TrelloReport::Card.array_attributes
        self.to_array.each { |card| csv << card }
      end
    end
  end
end