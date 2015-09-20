require 'spec_helper'

describe "done stories table", type:  :feature, js: true do
  include_context "authentication"

  let(:iteration) { user_profile.beginning_of_current_iteration }
  let(:table_title) { "Completed work" }

  before do
    (1..2).each { |e| FactoryGirl.create(:done_story, user_profile: user_profile, iteration: iteration.strftime("%Y-%m-%d"), timestamp: iteration.strftime("%Y-%m-%d"), estimate: e, status: JSON.parse(user_profile.done_lists).keys.first, label_names: 'red', type_of_work: user_profile.labels_types_of_work.split(",").first) }
    authenticate 
  end
  
  subject do
    visit "/table/done-stories/#{iteration.strftime("%Y-%m-%d")}"
    page
  end
  
  it { subject.first("tr.story td.labels", text: "red")}

  it_behaves_like "a table"
  it_behaves_like "a paginatable visualization"
  
end