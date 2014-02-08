require 'spec_helper'

describe "routes" do
  
  context "homepage" do
    subject { { get: "/" } }
    it { should route_to(controller: "homepage", action: "index")}
  end
 
  context "webhooks" do
    context "burn_up" do
      subject { { post: "ian4atzhmmh9ul/burn-up.json" } }
      it { should route_to(controller: "webhooks", action: "burn_up", format: "json")}

      context "head test" do
        subject {{ head: "ian4atzhmmh9ul/burn-up.json"}}
        it { should route_to(controller: "webhooks", action: "burn_up", format: "json")}
      end
      context "format constraint" do
        subject { { post: "ian4atzhmmh9ul/burn-up" } }
        it { should_not route_to(controller: "webhooks", action: "burn_up")}
      end

      context "add" do
        subject { { get: "ian4atzhmmh9ul/burn-up/add" } }
        it { should route_to(controller: "webhooks", action: "burn_up_add")}
      end

      context "delete" do
        subject { { get: "ian4atzhmmh9ul/burn-up/delete" } }
        it { should route_to(controller: "webhooks", action: "burn_up_delete")}
      end
    end
  end
  
  context "charts" do
    context "burn_up" do
      subject { { get: "chart/burn-up" } }
      it { should route_to(controller: "charts", action: "burn_up")}
    end
    context "burn_up_reload" do
      subject { { get: "chart/burn-up-reload" } }
      it { should route_to(controller: "charts", action: "burn_up_reload")}
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
    context "done stories" do
      subject { { get: "table/done-stories" } }
      it { should route_to(controller: "tables", action: "done_stories")}
    end
  end
  
  context "reports" do
    context "performance summary" do
      subject { { get: "report/performance-summary" } }
      it { should route_to(controller: "reports", action: "performance_summary")}
    end
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
      subject { { get: "user/Bk2meuxQzLYkdkmLsoTkVZMgfAbb9h" } }
      it { should route_to(controller: "users", action: "create")}
    end
    context "create_submit" do
      subject { { post: "user/Bk2meuxQzLYkdkmLsoTkVZMgfAbb9h" } }
      it { should route_to(controller: "users", action: "create_submit")}
    end
    context "delete" do
      subject { { get: "user/rplku4rpppypeu6npzwcxwxqagisaj/username" } }
      it { should route_to(controller: "users", action: "delete", name: "username")}
    end
  end
end
