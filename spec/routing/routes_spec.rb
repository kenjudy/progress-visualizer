require 'spec_helper'

describe "routes" do
  
  context "homepage" do
    subject { { get: "/" } }
    it { should route_to(controller: "charts", action: "burn_up")}
  end
 
  context "charts" do
    context "burn_up" do
      subject { { get: "chart/burn-up" } }
      it { should route_to(controller: "charts", action: "burn_up")}
    end
    context "yesterdays_weather" do
      subject { { get: "chart/yesterdays-weather" } }
      it { should route_to(controller: "charts", action: "yesterdays_weather")}
      context "optional param" do
        subject { { get: "chart/yesterdays-weather/10" } }
        it { should route_to(controller: "charts", action: "yesterdays_weather", weeks: "10")}
      end
      context "optional param constraints" do
        subject { { get: "chart/yesterdays-weather/bad" } }
        it { should_not route_to(controller: "charts", action: "yesterdays_weather", weeks: "bad")}
      end
    end
    context "long_term_trend" do
      subject { { get: "chart/long-term-trend" } }
      it { should route_to(controller: "charts", action: "long_term_trend")}
      context "optional param" do
        subject { { get: "chart/long-term-trend/10" } }
        it { should route_to(controller: "charts", action: "long_term_trend", weeks: "10")}
      end
      context "optional param constraints" do
        subject { { get: "chart/long-term-trend/bad" } }
        it { should_not route_to(controller: "charts", action: "long_term_trend", weeks: "bad")}
      end
    end
  end

  context "tables" do
    subject { { get: "table/overview" } }
    it { should route_to(controller: "tables", action: "overview")}
  end
  
  context "users" do
    context "logout" do
      subject { { get: "user/logout" } }
      it { should route_to(controller: "users", action: "logout")}
    end
    context "forgot" do
      subject { { get: "user/forgot/name" } }
      it { should route_to(controller: "users", action: "forgot_password", name: "name")}
    end
    context "create" do
      subject { { post: "user/Bk2meuxQzLYkdkmLsoTkVZMgfAbb9h" } }
      it { should route_to(controller: "users", action: "create")}
    end
    context "delete" do
      subject { { get: "user/rplku4rpppypeu6npzwcxwxqagisaj" } }
      it { should route_to(controller: "users", action: "delete")}
    end
  end
end
