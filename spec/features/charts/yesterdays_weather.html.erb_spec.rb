require 'spec_helper'

describe "yesterday's weather chart", type:  :feature, js: true do
  include_context "authentication"

  let(:iteration) { double(DateTime).as_null_object }

  before do
    (1..3).each do |i|
      date = (user_profile.beginning_of_current_iteration - (i * user_profile.duration).days).strftime("%Y-%m-%d")
      (1..2).each { |e| FactoryGirl.create(:done_story, user_profile: user_profile, iteration: date, timestamp: date, estimate: e, type_of_work: user_profile.labels_types_of_work.split(",").first) }
    end
    authenticate 
  end
  
  subject do
    visit "/chart/yesterdays-weather/#{iteration.strftime("%Y-%m-%d")}"
    page
  end
  
  context "stories" do
    let(:chart_id) { "#yesterdays_weather_stories_chart"}
    it_behaves_like "a graph"
  end
  context "estimates" do
    let(:chart_id) { "#yesterdays_weather_estimate_chart"}
    it_behaves_like "a graph"
  end
  
end