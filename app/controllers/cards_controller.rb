class CardsController < ApplicationController
  include UserProfileConcern
  include ChartsConcern

  before_filter :authenticate_user!, :assign_user_profile
  
  def show
    @card = Rails.cache.fetch("Card|#{user_profile.id}|#{params["card_id"]}", expires_in: 10.minutes) do
      card = Card.find(user_profile: user_profile, card_id: params["card_id"])
      card.activity
      card
    end
    @activity = CardActivity.activity_stream(@card.activity)
    @default_options = default_properties
  end

end
