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
  
  context "yesterdays_weather" do
    before { self.stub(yesterdays_weather_visualization: []) }
    subject { get :yesterdays_weather }
    
    its(:code) { "200" }

    context "assigns" do
      before { subject }
      it { assigns(:yesterdays_weather_chart_estimate_chart).should_not be_nil }
      it { assigns(:yesterdays_weather_chart_stories_chart).should_not be_nil }
    end
  end
  
  context "long_term_trend" do
    subject { get :long_term_trend }
    
    its(:code) { "200" }

    context "assigns" do
      before { subject }
      it { assigns(:long_term_trend_chart).should_not be_nil }
    end
  end
end
