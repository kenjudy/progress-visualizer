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
    end
    context "long_term_trend" do
      subject { { get: "charts/long-term-trend" } }
      it { should route_to(controller: "charts", action: "long_term_trend")}
    end
  end
  context "tables" do
    subject { { get: "tables/overview" } }
    it { should route_to(controller: "tables", action: "overview")}
  end
end
