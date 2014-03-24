require 'spec_helper'

describe "done stories table", type:  :feature, js: true do
  include_context "authentication"

  let(:iteration) { user_profile.beginning_of_current_iteration }
  let(:table_title) { "Completed work" }

  before do
    (1..2).each { |e| FactoryGirl.create(:done_story, user_profile: user_profile, iteration: iteration.strftime("%Y-%m-%d"), timestamp: iteration.strftime("%Y-%m-%d"), estimate: e, status: JSON.parse(user_profile.done_lists).keys.first, type_of_work: user_profile.labels_types_of_work.split(",").first) }
    authenticate 
  end
  
  subject do
    visit "/report/performance-summary/#{iteration.strftime("%Y-%m-%d")}"
    page
  end
  
  it { subject.find("tr.list th", text: "red")}

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

  it_behaves_like "a paginatable visualization"
  
end