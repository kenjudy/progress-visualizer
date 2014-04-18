require 'redcarpet'

class CardActivity < TrelloObject

  attr_accessor :previous_type

  attr_reader :type, :agent, :verb, :direct_object

  alias_method :activity, :data
  
  TYPES = {
    "addAttachmentToCard" => { verb: "attached", direct_object: "attachment" },
    "addMemberToCard" => { verb: "added", direct_object: "member" },
    "addChecklistToCard" => { verb: "added checklist", direct_object: "checklist"},
    "commentCard" => { verb: "commented", direct_object: "card"},
    "createCard" => { verb: "created", direct_object: "card"},
    "copyCard" => { verb: "copied", direct_object: "card"},
    "convertToCardFromCheckItem" => { verb: "converted", direct_object: "checkitem"},
    "deleteAttachmentFromCard" => { verb: "deleted attachment", direct_object: "attachment" },
    "moveCardFromBoard" => { verb: "moved card from board", direct_object: "board" },
    "moveCardToBoard" => { verb: "moved card to board", direct_object: "board" },
    "removeChecklistFromCard" => { verb: "removed checklist", direct_object: "checklist" },
    "removeMemberFromCard" => { verb: "removed", direct_object: "member" },
    "updateCheckItemStateOnCard" => { verb: "updated checklist", direct_object: "checklist" },
    "updateCard" => { verb: "updated", direct_object: "card"},
  }.freeze
  
  def assign_attributes(activity)
    @type = activity["type"]
    @agent = activity["memberCreator"]["fullName"]
  end
  
  def redundant?
    (previous_type == "updateCard" && activity["data"]["card"]["pos"]) ||
    (previous_type == type && type == "updateCheckItemStateOnCard")
  end
  
  def to_html
    "<span class=\"agent\">#{agent}</span> <span class=\"verb\">#{verb}</span> <span class=\"direct-object #{TYPES[@type][:direct_object]}\">#{direct_object}</span>".html_safe if verb
  end
  
  def verb
    @verb ||= @type == "updateCard" ? verb_for_card_update : TYPES[@type][:verb]
  end
  
  def direct_object
    @direct_object ||=
    case type
    when "addAttachmentToCard"
      activity["data"]["attachment"]["name"]
    when "addMemberToCard"
      "#{activity["member"]["fullName"]} to this card"
    when "addChecklistToCard"
      activity["data"]["checklist"]["name"]
    when "commentCard"
      markdown.render(activity["data"]["text"])
    when "createCard"
      "this card"
    when "copyCard"
      "this card"
    when "convertToCardFromCheckItem"
      "checklist item to card"
    when "deleteAttachmentFromCard"
      activity["data"]["attachment"]["name"]
    when "moveCardFromBoard"
      activity["data"]["board"]["name"]
    when "moveCardToBoard"
      activity["data"]["board"]["name"]
    when "removeChecklistFromCard"
      activity["data"]["checklist"]["name"]
    when "removeMemberFromCard"
      "#{activity["member"]["fullName"]} from this card"
    when "updateCard"
      if activity["data"]["listBefore"]
        activity["data"]["listAfter"]["name"]
      else
        if activity["data"]["old"]["pos"]
          "#{activity["data"]["card"]["pos"] - activity["data"]["old"]["pos"] < 0 ? "up" : "down"} in priority"
        elsif activity["data"]["old"]["name"]
          activity["data"]["card"]["name"]
        elsif activity["data"]["old"]["desc"]
          markdown.render(activity["data"]["card"]["desc"]).html_safe
        elsif !activity["data"]["old"]["closed"].nil?
          "this card"
        end
      end

    when "updateCheckItemStateOnCard"
      activity["data"]["checklist"]["name"]
    end
    
  end
  
  def timestamp(precision)
    datetime = DateTime.parse(activity["date"]).in_time_zone.strftime('%s').to_i
    timestamp = (datetime - (precision > 0 ? datetime % precision : 0)).to_s
  end
  
  def self.activity_stream(activities)
    group_by_timestamp(activities, 300)
  end
  
  def self.group_by_timestamp(activities, precision)
    groups = {}
    previous_type = nil
    activities.each do |activity|
      card_activity = CardActivity.new(activity)
      card_activity.previous_type = previous_type
      timestamp = card_activity.timestamp(precision)
      groups[timestamp] ||= []
      groups[timestamp] << card_activity unless card_activity.redundant?
      previous_type = card_activity.type
    end
    groups
  end
  
  def self.find_by(args)
    BaseAdapter.build_adapter(args[:user_profile]).request_card_activity_data(args[:card_id])
  end
  
  private
  
  def verb_for_card_update
    if activity["data"]["listBefore"]
      "moved this card from #{activity["data"]["listBefore"]["name"]} to"
    else
      if activity["data"]["old"]["pos"]
        "moved this card"
      elsif activity["data"]["old"]["name"]
        "renamed this card"
      elsif activity["data"]["old"]["desc"]
        "changed the description to"
      elsif !activity["data"]["old"]["closed"].nil?
        activity["data"]["old"]["closed"] ? "unarchived": "archived"
      end
    end
  end
  
  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
  end

end