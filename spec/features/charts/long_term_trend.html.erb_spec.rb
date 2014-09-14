require 'spec_helper'

describe "long term trend chart chart", type:  :feature, js: true do
  include_context "authentication"

  let(:iteration) { user_profile.beginning_of_current_iteration }

  before do
    (1..3).each do |i|
      date = (user_profile.beginning_of_current_iteration - (i * user_profile.duration).days).strftime("%Y-%m-%d")
      (1..2).each { |e| FactoryGirl.create(:done_story, user_profile: user_profile, iteration: date, timestamp: date, estimate: e, type_of_work: user_profile.labels_types_of_work.split(",").first) }
    end
    authenticate 
  end
  
  subject do
    visit "/chart/long-term-trend/1"
    page
  end
  
  context "chart" do
    let(:chart_id) { "#long_term_trend_chart"}
    it "should behave like a graph but capybara times out"
    #it_behaves_like "a graph"
  end
  
end