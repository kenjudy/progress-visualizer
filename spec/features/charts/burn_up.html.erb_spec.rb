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
    include_context "authentication"
    
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

      context "stories" do
        let(:chart_id) { "#stories_chart"}
        it_behaves_like "a graph"
      end
      context "estimates" do
        let(:chart_id) { "#estimates_chart"}
        it_behaves_like "a graph"
      end

      it { should have_content("Burn Up for Estimates #{iteration.strftime("%B %e, %Y")} - #{iteration.strftime("%B %e, %Y")}") }
      
      it_behaves_like "a paginatable graph"
    end
  end
end