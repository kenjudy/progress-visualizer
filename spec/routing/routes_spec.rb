require 'spec_helper'

describe "routes" do
  
  context "homepage" do
    subject { { get: "/" } }
    it { should route_to(controller: "charts", action: "daily_burnup")}
  end
 
  context "charts" do
    subject { { get: "charts/daily-burnup" } }
    it { should route_to(controller: "charts", action: "daily_burnup")}
  end
  context "tables" do
    subject { { get: "tables/overview" } }
    it { should route_to(controller: "tables", action: "overview")}
  end
end
