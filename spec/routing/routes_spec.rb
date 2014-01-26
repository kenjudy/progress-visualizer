require 'spec_helper'

describe "routes" do
  
  context "homepage" do
    subject { { get: "/" } }
    it { should route_to(controller: "charts", action: "daily_burnup")}
  end
 
  context "charts" do
    context "daily-burnup" do
      subject { { get: "charts/daily-burnup" } }
      it { should route_to(controller: "charts", action: "daily_burnup")}
    end
    context "yesterdays_weather" do
      subject { { get: "charts/yesterdays-weather" } }
      it { should route_to(controller: "charts", action: "yesterdays_weather")}
      context "optional param" do
        subject { { get: "charts/yesterdays-weather/10" } }
        it { should route_to(controller: "charts", action: "yesterdays_weather", weeks: "10")}
      end
      context "optional param constraints" do
        subject { { get: "charts/yesterdays-weather/bad" } }
        it { should_not route_to(controller: "charts", action: "yesterdays_weather", weeks: "bad")}
      end
    end
    context "long_term_trend" do
      subject { { get: "charts/long-term-trend" } }
      it { should route_to(controller: "charts", action: "long_term_trend")}
      context "optional param" do
        subject { { get: "charts/long-term-trend/10" } }
        it { should route_to(controller: "charts", action: "long_term_trend", weeks: "10")}
      end
      context "optional param constraints" do
        subject { { get: "charts/long-term-trend/bad" } }
        it { should_not route_to(controller: "charts", action: "long_term_trend", weeks: "bad")}
      end
    end
  end
  context "tables" do
    subject { { get: "tables/overview" } }
    it { should route_to(controller: "tables", action: "overview")}
  end
end
