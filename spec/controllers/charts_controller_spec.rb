require 'spec_helper'
require 'json'

describe ChartsController do
  include Trello::JsonData
  
  context "daily_burnup" do
    let(:card_data) { example_card_data }
    let(:board) { Trello::Board.new([card_data]) }
    before { Adapters::TrelloAdapter.stub(daily_burnup: board) }
    
    subject do
      get :daily_burnup
      response
    end
    
    its(:code) { "200" }
  end
end
