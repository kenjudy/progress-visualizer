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
    context "optional week param" do
      subject { get :yesterdays_weather, weeks: "3" }
      after { subject }
      it "should pass param to concern" do
        expect(controller).to receive(:yesterdays_weather_visualization).with({label: :estimate, weeks: 3}).ordered
        expect(controller).to receive(:yesterdays_weather_visualization).with({label: :stories, weeks: 3}).ordered
      end
    end
  end
  
  context "long_term_trend" do
    subject { get :long_term_trend }
    
    its(:code) { "200" }

    context "assigns" do
      before { subject }
      it { assigns(:long_term_trend_chart).should_not be_nil }
    end
    context "optional week param" do
      subject { get :long_term_trend, weeks: "3" }
      after { subject }
      it { expect(controller).to receive(:long_term_trend_visualization).with(3) }
    end
    
  end
end
