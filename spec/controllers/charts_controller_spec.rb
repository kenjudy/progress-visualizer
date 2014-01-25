require 'spec_helper'
require 'json'

describe ChartsController do
  include Trello::JsonData
  
  context "daily_burnup" do
    before { Adapters::TrelloAdapter.stub(daily_burnup: double("DailyBurnup").as_null_object) }
    
    subject { get :daily_burnup }
    
    its(:code) { "200" }
    
    context "assigns" do
      before { subject }
      it { assigns(:estimates_chart).should_not be_nil }
      it { assigns(:stories_chart).should_not be_nil }
    end
  end
end
