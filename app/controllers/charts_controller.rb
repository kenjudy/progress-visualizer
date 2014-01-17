class ChartsController < ApplicationController
  
  def daily_burnup
    @cards = Trello::Client.daily_burnup
  end
  
end
