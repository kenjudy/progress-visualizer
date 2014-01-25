module Trello
  class Card < TrelloObject
    
    attr_reader :id, :last_known_state, :date_last_activity, :description, :id_board, :id_list, :id_short, :name, :short_link, :badges, :due, :labels, :short_url, :url
    
    attr_accessor :list
    
    def assign_attributes(data)
      @id = @data["id"]
      @closed = @data["closed"]
      @date_last_activity = date_property(@data["dateLastActivity"])
      @description = @data["desc"]
      @id_board = @data["idBoard"]
      @id_list = @data["idList"]
      @id_short = @data["idShort"]
      @short_link = @data["shortLink"]
      @badges = @data["badges"]
      @due = date_property(@data["due"])
      @labels = @data["labels"]
      @short_url = @data["shortUrl"]
      @url = @data["url"]
    end
    
    def name
      @name ||= @data["name"].gsub(/^\([\d\.]+\) ?/,"")
    end
    
    def last_known_state
      @last_known_state ||= @data["checkItemStates"].last["state"] if @data["checkItemStates"] && @data["checkItemStates"].last
    end
    
    def closed? 
      @closed
    end
    
    def estimate
      @estimate ||= @data["name"].gsub(/^\(([\d\.]+)\).*$/,'\1').to_f
    end
    
    def number
      @id_short.to_i
    end
  
    def list_name
      list.name if list
    end

    def to_array
      arr = self.class.array_attributes.map{ |attr| attr == "labels" ? labels.map{|lbl| lbl["name"] }.join(",") : self.send(attr.to_sym)}
    end

    def self.array_attributes
      %w(number estimate name last_known_state closed? date_last_activity due labels id id_short id_board short_link short_url url id_list list_name)
    end
    
    private
    
    def date_property(field)
      Date.parse(field) if field
    end
  end
end
