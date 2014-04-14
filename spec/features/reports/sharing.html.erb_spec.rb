require 'spec_helper'
  
describe "report sharing", type: :feature, js: true do
  
  let(:report_sharing) { FactoryGirl.create(:report_sharing, url: "/report/performance-summary/2014-04-07") }
  let(:user_profile) { report_sharing.user_profile }
  let(:iteration) { Date.new(2014,04,07) }
  let(:table_title) { "Completed work" }

  before { (1..2).each { |e| FactoryGirl.create(:done_story, user_profile: user_profile, iteration: iteration.strftime("%Y-%m-%d"), timestamp: iteration.strftime("%Y-%m-%d"), estimate: e, status: JSON.parse(user_profile.done_lists).keys.first, type_of_work: user_profile.labels_types_of_work.split(",").first) }
 }
  subject do
    visit "/report/sharing/#{report_sharing.guid}"
    page
  end

  it { subject.has_no_css?("#pager") }

  it_behaves_like "a table"
  
  context "yesterday's weather" do
    context "stories" do
      let(:chart_id) { "#yesterdays_weather_stories_chart"}
      it_behaves_like "a graph"
    end
  
    context "estimates" do
      let(:chart_id) { "#yesterdays_weather_estimate_chart"}
      it_behaves_like "a graph"
    end
  end

  context "long term trend" do
    let(:chart_id) { "#long_term_trend_chart"}
    it_behaves_like "a graph"
  end
  
 # it { subject; save_screenshot("tmp/screenshots/report_sharing.png", full: true) }

end