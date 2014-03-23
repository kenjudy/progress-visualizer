require 'spec_helper'

describe "done stories table", type:  :feature, js: true do
  include_context "authentication"

  let(:iteration) { user_profile.beginning_of_current_iteration }
  let(:table_title) { "To Do's for" }
  
  before do
    user_profile.backlog_lists = "{\"52e6778d5922b7e16a641e59\":\"To Do\",\"52e6778d5922b7e16a641e5a\":\"Doing\"}"
    user_profile.labels_types_of_work = ""
    user_profile.save
    authenticate
  end
  
  subject do
    VCR.use_cassette('features/todo_stories') do
      visit "/table/todo-stories"
      page
    end
  end

  it_behaves_like "a table"

end