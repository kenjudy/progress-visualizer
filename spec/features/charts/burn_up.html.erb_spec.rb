require 'spec_helper'

describe "burn_up", type:  :feature, js: true do
  let(:iteration) { double(DateTime).as_null_object }
  
  subject do
    visit "/chart/burn-up/#{iteration.strftime("%Y-%m-%d")}"
    page
  end
  
  context "login prompt" do
    it { should have_content 'Sign in' }
  end
  
  context "authenticated" do
    before { authenticate }
    context "no data" do
      it { should have_content 'No burn up data'}
    end
    context "chart" do
      let(:iteration) { user_profile.beginning_of_current_iteration }
      before do
        FactoryGirl.create(:done_story, user_profile: user_profile, iteration: iteration.strftime("%Y-%m-%d"))
        FactoryGirl.create(:done_story, user_profile: user_profile, iteration: (iteration - user_profile.duration.days).strftime("%Y-%m-%d"))
        (0..3).each do |hr|
          FactoryGirl.create(:burn_up, user_profile: user_profile, timestamp: iteration + hr.hours)
        end
      end
      it("renders stories") do
        subject.find("#stories_chart svg")
        expect(subject.all("#stories_chart svg g").count).to be > 1
        #subject.save_screenshot('tmp/screenshots/burn_up_screenshot.png', :full => true)
      end
      it("renders estimates") do
        subject.find("#estimates_chart svg")
        expect(subject.all("#estimates_chart svg g").count).to be > 1
      end
      it { should have_content("Burn Up for Estimates #{iteration.strftime("%B %e, %Y")} - #{iteration.strftime("%B %e, %Y")}") }
      
      context "pagination" do
        before do
          FactoryGirl.create(:done_story, user_profile: user_profile, iteration: iteration.strftime("%Y-%m-%d"))
          FactoryGirl.create(:done_story, user_profile: user_profile, iteration: (iteration - user_profile.duration.days).strftime("%Y-%m-%d"))
        end
        
        it("previous/next") do
          subject.find(".pager .previous")
          click_link("Older")
          #subject.save_screenshot('tmp/screenshots/burn_up_previous_screenshot.png', :full => true)
          subject.find(".pager .next")
          assert_no_selector(".next.disabled")
        end
      end
      
    end
  end
end