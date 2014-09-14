require 'spec_helper'

describe ApplicationHelper, type: :helper do
  let(:request) { double("Request", fullpath: homepage_path).as_null_object }
  
  context "date_pills" do
    subject { date_pills(1.year.ago.to_date)}
    it { is_expected.to eq([11, 22, 33, 44, 55]) }
  end

  context "duration_in_weeks" do
    {"One week" => 7,"Two weeks" => 14, "Three weeks" => 21, "Four weeks" => 28}.each do |label, days|
      context "#{label}" do
        let(:label) { label }
        let(:days) { days }
        subject { duration_in_weeks(days) }

        it { is_expected.to eq(label) }

      end
    end
    context "days is nil" do
      subject { duration_in_weeks(nil) }
      it { is_expected.to eq("One week")}
    end
  end

  context "underscore_join_words" do
    subject { underscore_join_words("Done Stories") }

    it { is_expected.to eq("'done_stories'")}

    context "strip quote" do
      subject { underscore_join_words("Yesterday's Weather") }

      it { is_expected.to eq("'yesterdays_weather'")}
    end
  end

  context "menu_list_item" do
    subject { menu_list_item("Burn Up<span></span>", charts_burn_up_path) }

    it { is_expected.to eq("<li class=\" \"><a href=\"/chart/burn-up\" onClick=\"_gaq.push([&#39;_trackEvent&#39;, &#39;header_menu&#39;, &#39;burn_up&lt;span&gt;&lt;/span&gt;&#39;]);\">Burn Up<span></span></a></li>") }
  end

  context "active class if" do

    subject { active_class_if(charts_burn_up_path) }

    context "match" do
      before { allow(request).to receive_messages(fullpath: charts_burn_up_path)}
      it { is_expected.to eq("active") }

      context "multiple path args" do
        subject { active_class_if([charts_burn_up_path, tables_done_stories_path]) }
        it { is_expected.to eq("active") }
      end

      context "path with date param" do
        before { allow(request).to receive_messages(fullpath: charts_burn_up_path(iteration: "2014-03-14"))}
        it { is_expected.to eq("active") }
      end

      context "path with weeks param" do
        subject { active_class_if(charts_yesterdays_weather_path) }
        before { allow(request).to receive_messages(fullpath: charts_yesterdays_weather_path(weeks: "14"))}
        it { is_expected.to eq("active") }
      end
    end

    context "no match" do
      it { is_expected.not_to eq("active") }
    end

  end

  context "time_options" do
    subject { time_options(10) }
    it { is_expected.to match(/<option selected="selected" value="10">10 AM<\/option>/)}
  end
end