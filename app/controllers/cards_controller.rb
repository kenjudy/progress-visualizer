require 'redcarpet'

class CardsController < ApplicationController
  include UserProfileConcern
  include ChartsConcern

  before_filter :authenticate_user!, :assign_user_profile
  
  def show
    @card = Rails.cache.fetch("Card/#{user_profile.id}/#{params["card_id"]}", expires_in: 10.minutes) do
      card = Card.find(user_profile: user_profile, card_id: params["card_id"])
      card.activity
      card
    end
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    @description = markdown.render(@card.description).html_safe
    @activity = collate_activities(@card, markdown)
    @default_options = default_properties
  end
  
  def collate_activities(card, markdown)
    activities = {}
    previous_type = nil
    card.activity.each do |activity|
      datetime = DateTime.parse(activity["date"]).strftime('%s').to_i
      timestamp = (datetime - datetime % 300).to_s
      activities[timestamp] ||= []
      activity_description = activity_description(activity, previous_type, markdown)
      if activity_description
        activities[timestamp] << activity_description
        previous_type = activity_description[:type]
      else
        previous_type = nil
      end
    end
    activities
  end
  
  def activity_description(activity, previous_type, markdown)
    message =
    case activity["type"]
    when "addAttachmentToCard"
      "attached <span class=\"text-muted\">#{activity["data"]["attachment"]["name"]}</span>"
    when "addMemberToCard"
      "added #{activity["member"]["fullName"]} to this card"
    when "addChecklistToCard"
      "added checklist <span class=\"text-muted\">#{activity["data"]["checklist"]["name"]}</span>"
    when "commentCard"
      "&mdash; #{markdown.render(activity["data"]["text"])}"
    when "createCard"
      "created this card"
    when "copyCard"
      "copied this card"
    when "convertToCardFromCheckItem"
      "converted checklist item to card"
    when "deleteAttachmentFromCard"
      "deleted <span class=\"text-muted\">#{activity["data"]["attachment"]["name"]}</span>"
    when "moveCardFromBoard"
      "moved card from board #{activity["data"]["board"]["name"]}"
    when "moveCardToBoard"
      "moved card to board #{activity["data"]["board"]["name"]}"
    when "removeChecklistFromCard"
      "removed checklist <span class=\"text-muted\">#{activity["data"]["checklist"]["name"]}</span>"
    when "removeMemberFromCard"
      "removed #{activity["member"]["fullName"]} from this card"
    when "updateCard"
      if activity["data"]["listBefore"]
        "moved this card from <strong>#{activity["data"]["listBefore"]["name"]}</strong> to <strong>#{activity["data"]["listAfter"]["name"]}</strong>"
      else
        update_card_description(activity["data"], markdown, previous_type)
      end
    when "updateCheckItemStateOnCard"
      "updated checklist <span class=\"text-muted\">#{activity["data"]["checklist"]["name"]}</span>"
    else
      activity.inspect
    end

    {type:  activity["type"], description: "<strong>#{activity["memberCreator"]["fullName"]}</strong> #{message}".html_safe} if message
    
  end
  
  def update_card_description(data, markdown, previous_type = nil)
    return nil unless data["old"]

    if data["old"]["pos"] && previous_type != "updateCard"
      direction = data["card"]["pos"] - data["old"]["pos"] < 0 ? "up" : "down"
      "moved this card #{direction} in priority"
    elsif data["old"]["name"]
      "renamed this card <strong>#{data["card"]["name"]}</strong>"
    elsif data["old"]["desc"]
      "change the description to <span class=\"text-muted\">#{markdown.render(data["card"]["desc"]).html_safe}</span>"
    elsif !data["old"]["closed"].nil?
      "#{data["old"]["closed"] ? "unarchived": "archived" } this card"
    end
    
  end
end
