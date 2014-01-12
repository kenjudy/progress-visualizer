require 'json'

module TrelloReport
  class TrelloObject

    attr_reader :json
    
    def initialize(json)
      @json = json
    end
    
    
  end
end
