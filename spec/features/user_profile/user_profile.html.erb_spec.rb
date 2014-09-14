require 'spec_helper'

shared_examples "the userprofile detail form" do
  include ActionView::Helpers::TextHelper
  
  before do
    find("#backlog_lists_cloud_selector").click_button("To Do") #deselect default
    find("#backlog_lists_cloud_selector").click_button("To Do") #reselect
    find("#backlog_lists_cloud_selector").click_button("Doing") #deselect default
    find("#backlog_lists_cloud_selector").click_button("Doing") #reselect
    find("#done_lists_cloud_selector").click_button("Done") #deselect default
    find("#done_lists_cloud_selector").click_button("Done") #reselec

    #confirm cloud selector is working
    find("#labels_types_of_work_cloud_selector").click_button("red") #select
    expect(find("#user_profile_labels_types_of_work").value).to eql("red")
    find(".btn-info", text: "red")
    find("#labels_types_of_work_cloud_selector").click_button("red") #deselect
    expect(find("#user_profile_labels_types_of_work").value).to eql("")
    find(".btn-default", text: "red")
    find("#labels_types_of_work_cloud_selector").click_button("red") #select
    expect(find("#user_profile_labels_types_of_work").value).to eql("red")
    find(".btn-info", text: "red")

    select("Tuesday", from: "user_profile_start_day_of_week")
    select("11 AM", from: "user_profile_start_hour")
    select("Friday", from: "user_profile_end_day_of_week")
    select("11 PM", from: "user_profile_end_hour")
    select("Two weeks", from: "user_profile_duration")
    find("#user_profile_start_date_2i")
    select("March", from: "user_profile_start_date_2i")
    select("11", from: "user_profile_start_date_3i")
    select("2014", from: "user_profile_start_date_1i")
    VCR.use_cassette("features/#{action}_detail_form_add_webhook") do
      click_button("Submit")
    end
    #save_screenshot("tmp/screenshots/#{action}_detail_form.png", full: true)
  end
  
  subject { page }
  
  #combining into one spec saves 13 seconds per example...
  it("saves detail") do
    expect(subject).to have_content "You've created #{pluralize(user_profile.user.user_profiles.count, "profile")}"
    profile = user_profile.user.default_profile
    
    expect(profile.current_sprint_board_id).to eql("52e6778d5922b7e16a641e58")
    expect(profile.backlog_lists).to eql("{\"52e6778d5922b7e16a641e59\":\"To Do\",\"52e6778d5922b7e16a641e5a\":\"Doing\"}")
    expect(profile.done_lists).to eql("{\"52e6778d5922b7e16a641e5b\":\"Done\"}")
    expect(profile.labels_types_of_work).to eql("red")
    expect(profile.duration).to eql(14)
    expect(profile.start_day_of_week).to eql(2)
    expect(profile.end_day_of_week).to eql(5)
    expect(profile.start_hour).to eql(11)
    expect(profile.end_hour).to eql(23)
    expect(profile.start_date).to eql(Date.new(2014,03,11))
  end
  
end

describe "user_profile", type:  :feature, js: true do
  include_context "authentication"
  
  before { authenticate }
  
  context "get" do
    subject do
      visit "/user_profiles"
      click_link("Add")
      page
    end  
  
    it { is_expected.to have_content 'User Profile (Trello Properties)'}
  end
  
  context "new" do
    let(:action) { "create_user_profile" }
    before do 
      VCR.use_cassette("features/#{action}") do
        visit "/user_profiles/new"
        click_button("Cancel")
        fill_in "user_profile_readonly_token", with: "1cbfcbf7876628e1367483189818f3eb8d2c92525b6fc314e0008fb1f8634foo"
        fill_in "user_profile_name", with: "Test Name"
        check "user_profile_default"
        fill_in "user_profile_current_sprint_board_id_short", with: "WWtHBRod"
        click_button("Submit")
      end
    end

    it_behaves_like("the userprofile detail form")
    
    it("saves first page") do
      profile = user_profile.user.default_profile
    
      expect(profile.name).to eql("Test Name")
      expect(profile.default).to eql("1")
      expect(profile.readonly_token).to eql("1cbfcbf7876628e1367483189818f3eb8d2c92525b6fc314e0008fb1f8634foo")
      expect(profile.current_sprint_board_id_short).to eql("WWtHBRod")
    end
    
  end
  
  context "edit" do
    let(:action) { "edit_user_profile" }
    before do
      user_profile.update_attributes(done_lists: "{}", backlog_lists: "{}", labels_types_of_work: "")
      VCR.use_cassette("features/#{action}") do
        visit "/user_profiles/#{user_profile.id}/edit"
      end
    end
    
    it_behaves_like("the userprofile detail form")
  end
  
  context "show" do
    subject do
      visit "/user_profiles/#{user_profile.id}"
      page
    end
    
    it "indicates current profile" do
      subject.find("tr.profile_#{user_profile.id.to_s}", text: "#{user_profile.name} (selected)")
    end
  end
  
  context "destroy" do
    subject do
      visit "/user_profiles/#{user_profile.id}"
      find("tr.profile_#{user_profile.id.to_s}").click_link("delete")
      page
    end
    
    it("destroys") do
      is_expected.to have_content "Destroyed"
      expect(UserProfile.all.count).to eq(0)
    end
    
  end
end