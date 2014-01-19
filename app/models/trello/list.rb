require 'json'

module Trello
  class List < TrelloObject
  
    attr_reader :id, :name
    
    def assign_attributes(data)
      @id = @data["id"]
      @name = @data["name"]
    end
  end
  
end