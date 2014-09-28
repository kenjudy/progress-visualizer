require 'spec_helper'

describe "routes", type: :routing do

  context "homepage" do
    subject { { get: "/" } }
    it { is_expected.to route_to(controller: "homepage", action: "index")}
  end

  context "about" do
    subject { { get: "/about"} }
    it { is_expected.to route_to(controller: "about", action: "index") }
  end

  context "release-notes" do
    subject { { get: "/release-notes"} }
    it { is_expected.to route_to(controller: "about", action: "release_notes") }
  end

  context "terms-and-conditions" do
    subject { { get: "/terms-and-conditions"} }
    it { is_expected.to route_to(controller: "about", action: "terms_and_conditions") }
  end

  context "privacy-policy" do
    subject { { get: "/privacy-policy"} }
    it { is_expected.to route_to(controller: "about", action: "privacy_policy") }
  end

  context "help" do
    subject { { get: "/help"} }
    it { is_expected.to route_to(controller: "help", action: "index") }
  end

  context "contact_form new" do
    subject { { post: "/contact_form/create"} }
    it { is_expected.to route_to(controller: "contact_form", action: "create") }
  end

  context "contact_form new" do
    subject { { get: "/contact_form/new"} }
    it { is_expected.to route_to(controller: "contact_form", action: "new") }
  end

  context "user_profiles" do
    { index: [:get, "/", nil], show: [:get, "/1", "1"],
      new: [:get, "/new", nil], edit: [:get, "/1/edit", "1"],
      create: [:post, "/", nil], update: [:put, "/1", "1"],
      destroy: [:delete, "/1", "1"]
    }.each do |action, props|

      context action do
        subject { { props[0] => "user_profiles#{props[1]}" } }
        let(:params) {{controller: "user_profiles", action: action.to_s, id: props[2]}.keep_if { |key, val| val }}

        it { is_expected.to route_to(params) }
      end

    end
    context "set" do
      subject { { get: "user_profiles/set/1"}}
      it { is_expected.to route_to(controller: "user_profiles", action: "set", profile_id: "1")}
    end
  end

  context "webhooks" do
    context "burn_up" do
      subject { { post: "ian4atzhmmh9ul/burn-up/1.json" } }
      it { is_expected.to route_to(controller: "webhooks", action: "burn_up", profile_id: "1", format: "json")}

      context "head test" do
        subject {{ head: "ian4atzhmmh9ul/burn-up/1.json"}}
        it { is_expected.to route_to(controller: "webhooks", action: "burn_up", profile_id: "1", format: "json")}
      end
      context "format constraint" do
        subject { { post: "ian4atzhmmh9ul/burn-up/1" } }
        it { is_expected.not_to route_to(controller: "webhooks", action: "burn_up")}
      end

    end
  end

  context "cards" do
    subject {{get: "cards/12344"}}
    it { is_expected.to route_to(controller: "cards", action: "show", card_id: "12344")}
  end

  context "charts" do
    context "burn_up" do
      subject { { get: "chart/burn-up" } }
      it { is_expected.to route_to(controller: "charts", action: "burn_up")}
      context "with iteration" do
        subject { { get: "chart/burn-up/2014-02-24" } }
        it { is_expected.to route_to(controller: "charts", action: "burn_up", iteration: "2014-02-24")}
      end
    end
    context "burn_up_reload" do
      subject { { get: "chart/burn-up-reload" } }
      it { is_expected.to route_to(controller: "charts", action: "burn_up_reload")}
    end
    context "yesterdays_weather" do
      subject { { get: "chart/yesterdays-weather" } }
      it { is_expected.to route_to(controller: "charts", action: "yesterdays_weather")}
      context "optional param" do
        subject { { get: "chart/yesterdays-weather/10" } }
        it { is_expected.to route_to(controller: "charts", action: "yesterdays_weather", weeks: "10")}
      end
      context "optional param constraints" do
        subject { { get: "chart/yesterdays-weather/bad" } }
        it { is_expected.not_to route_to(controller: "charts", action: "yesterdays_weather", weeks: "bad")}
      end
    end
    context "long_term_trend" do
      subject { { get: "chart/long-term-trend" } }
      it { is_expected.to route_to(controller: "charts", action: "long_term_trend")}
      context "optional param" do
        subject { { get: "chart/long-term-trend/10" } }
        it { is_expected.to route_to(controller: "charts", action: "long_term_trend", weeks: "10")}
      end
      context "optional param constraints" do
        subject { { get: "chart/long-term-trend/bad" } }
        it { is_expected.not_to route_to(controller: "charts", action: "long_term_trend", weeks: "bad")}
      end
    end
  end

  context "tables" do
    context "done stories" do
      subject { { get: "table/done-stories" } }
      it { is_expected.to route_to(controller: "tables", action: "done_stories")}
      context "done stories" do
        subject { { get: "table/done-stories/2014-03-14" } }
        it { is_expected.to route_to(controller: "tables", action: "done_stories", iteration: "2014-03-14")}
      end
    end
    context "todo stories" do
      subject { { get: "table/todo-stories" } }
      it { is_expected.to route_to(controller: "tables", action: "todo_stories")}
    end
  end

  context "reports" do
    context "performance summary" do
      subject { { get: "report/performance-summary" } }
      it { is_expected.to route_to(controller: "reports", action: "performance_summary")}
      context "with iteration" do
        subject { { get: "report/performance-summary/2014-02-24" } }
        it { is_expected.to route_to(controller: "reports", action: "performance_summary", iteration: "2014-02-24")}
      end
    end
    
    context "report sharing" do
      context "view" do
        subject { { get: "report/sharing/GUID"}}
        it { is_expected.to route_to(controller: "reports", action: "sharing", guid: "GUID")}
      end
      context "new" do
        let(:report) { 'performance-summary'}
        subject { { post: "report/sharing/#{report}/new"}}
        it { is_expected.to route_to(controller: "reports", action: "sharing_new", report: 'performance-summary')}
        context "report constraint" do
          let(:report) { 'non-existant-report' }
          it { is_expected.not_to route_to(controller: "reports", action: "sharing_new", report: 'performance-summary')}
        end
      end
    end
    
    context "admin" do
      context "users" do
        subject { { get: "admin/users"}}
        it { is_expected.to route_to(controller: "admin", action: "users")}
      end
      context "cards" do
        subject { { get: "admin/cards"}}
        it { is_expected.to route_to(controller: "admin", action: "cards")}
      end
    end
  end

end
