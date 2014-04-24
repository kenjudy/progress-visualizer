require 'redcarpet'

class Card < TrelloObject

  attr_accessor :id, :last_known_state, :date_last_activity, :description, :id_board, :id_list, :id_short, :name, :short_link, :badges, :due, :labels, :short_url, :url, :user_profile, :list
  
  attr_reader :estimate
  
  alias_method :parse_name, :name=
  
  def assign_attributes(data)
    @id = @data["id"]
    parse_name(@data["name"])
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
    @user_profile = @data[:user_profile]
  end
  
  def name=(name)
    parse_name(name)
  end
  
  def last_known_state
    @last_known_state ||= @data["checkItemStates"].last["state"] if @data["checkItemStates"] && @data["checkItemStates"].last
  end
  
  def description_html
    return @description_html if @description_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    @description_html = markdown.render(@description).html_safe
    @description_html
  end

  def closed?
    @closed
  end

  def number
    @id_short.to_i
  end

  def list_name
    list.name if list
  end
  
  def activity
    @activity ||= CardActivity.find_by({user_profile: user_profile, card_id: id })
  end

  def to_array
    arr = self.class.array_attributes.map{ |attr| attr == "labels" ? labels.map{|lbl| lbl["name"] }.join(",") : self.send(attr.to_sym)}
  end

  def self.array_attributes
    %w(number estimate name last_known_state closed? date_last_activity due labels id id_short id_board short_link short_url url id_list list_name)
  end

  def self.find(args)
    Card.new(BaseAdapter.build_adapter(args[:user_profile]).request_card_data(args[:card_id]).merge(user_profile: args[:user_profile]))
  end

  def self.find_by(args)
    args[:board_id] ||= args[:user_profile].current_sprint_board_id
    cards_data =
    if args[:all]
      BaseAdapter.build_adapter(args[:user_profile]).request_all_cards_data(args[:board_id])
    else
      BaseAdapter.build_adapter(args[:user_profile]).request_cards_data(args[:board_id])
    end
    cards_data.map{ |data| Card.new(data.merge(user_profile: args[:user_profile])) }
  end

  private
  
  def parse_name(name = "")
    @name = name.gsub(/^\([\d\.]+\) ?/,"")
    @estimate = name.gsub(/^\(([\d\.]+)\).*$/,'\1').to_f
  end
  
  def date_property(field)
    DateTime.parse(field) if field
  end
end
