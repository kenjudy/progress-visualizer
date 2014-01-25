require 'spec_helper'
require 'json'

describe ChartsController do
  include Trello::JsonData
  
  context "daily_burnup" do
    before { Adapters::TrelloAdapter.stub(daily_burnup: double("DailyBurnup").as_null_object) }
    
    after do
      get :daily_burnup
      response
    end
    
    its(:code) { "200" }
    it { assigns(:estimates_chart)}
    it { assigns(:stories_chart)}
  end
end
