class ChartsController < ApplicationController
  
  def daily_burnup
    @board = Adapters::TrelloAdapter.daily_burnup
  end
  
end
