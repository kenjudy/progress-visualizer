require 'json'

module Trello
  class Card < TrelloObject
    
    attr_reader :id, :last_known_state, :date_last_activity, :description, :id_board, :id_list, :name, :short_link, :badges, :due, :labels, :short_url, :url
    
    def initialize(json)
      super
      @id = json["id"]
      @closed = json["closed"]
      @date_last_activity = date_property(json["dateLastActivity"])
      @description = json["desc"]
      @id_board = json["idBoard"]
      @id_list = json["idList"]
      @id_short = json["idShort"]
      @short_link = json["shortLink"]
      @badges = json["badges"]
      @due = date_property(json["due"])
      @labels = json["labels"]
      @short_url = json["shortUrl"]
      @url = json["url"]
    end
    
    def name
      @name ||= json["name"].gsub(/^\([\d\.]+\) ?/,"")
    end
    
    def last_known_state
      @last_known_state ||= json["checkItemStates"].last["state"] if json["checkItemStates"] && json["checkItemStates"].last
    end
    
    def closed? 
      @closed
    end
    
    def estimate
      @estimate ||= json["name"].gsub(/^\(([\d\.]+)\).*$/,'\1').to_f
    end
    
    def number
      @id_short.to_i
    end
  
    def to_array
      self.class.array_attributes.map{ |attr| attr == "labels" ? labels.map{|lbl| lbl["name"] }.join(", ") : self.send(attr.to_sym)}
    end

    def self.array_attributes
      %w(number estimate name last_known_state closed? date_last_activity due labels id id_board id_list short_link short_url url)
    end
    
    private
    
    def date_property(field)
      Date.parse(field) if field
    end
  end
end
