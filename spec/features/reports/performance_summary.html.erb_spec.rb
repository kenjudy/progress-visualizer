require 'spec_helper'

describe "performance summary", type:  :feature, js: true do
  include_context "authentication"

  let(:iteration) { Date.new(2014,4,7) }
  let(:iteration_s) { iteration.strftime("%Y-%m-%d")}
  let(:table_title) { "Completed work" }

  before do
    (1..2).each { |e| FactoryGirl.create(:done_story, user_profile: user_profile, iteration: iteration_s, timestamp: iteration_s, estimate: e, status: JSON.parse(user_profile.done_lists).keys.first, type_of_work: user_profile.labels_types_of_work.split(",").first) }
    authenticate 
  end
  
  subject do
    visit "/report/performance-summary/#{iteration_s}"
    page
  end
  
  it { subject.first("tr.story td.labels", text: "red")}

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