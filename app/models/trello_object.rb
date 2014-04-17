require 'json'

class TrelloObject

  attr_reader :data

  def initialize(data)
    @data = data
    assign_attributes(data)
  end


end
