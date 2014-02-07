require 'spec_helper'
require 'json'

describe ChartsController do
  include ProgressVisualizerTrello::JsonData
  
  context "burn_up" do
    before { Adapters::TrelloAdapter.stub(burn_up: double("BurnUpChart").as_null_object) }
    
    subject { get :burn_up }
    
    its(:code) { should == "200" }
    
    context "assigns" do
      before { subject }
      it { assigns(:estimates_chart).should_not be_nil }
      it { assigns(:stories_chart).should_not be_nil }
    end
  end
  
  context "yesterdays_weather" do
    before { controller.stub(yesterdays_weather_visualization: []) }
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
      it("should present charts") { expect(controller).to receive(:yesterdays_weather_visualization).twice }
    end
  end
  
  context "long_term_trend" do
    subject { get :long_term_trend }
    
    its(:code) { should == "200" }

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
