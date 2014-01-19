require 'spec_helper'

describe ChartsController do
  context "daily_burnup" do
    before { Adapters::TrelloAdapter.stub(daily_burnup: Trello::Board.new)}
    subject do
      get :daily_burnup
      response
    end
    
    its(:code) { "200" }
  end
end
