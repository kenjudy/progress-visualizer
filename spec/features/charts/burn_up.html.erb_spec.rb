require 'spec_helper'

describe "burn_up", type:  :feature, js: false do
  #include IterationConcern
  
  subject do
    visit '/chart/burn-up' 
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
    # context "chart" do
    #   before do
    #     (0..3).each do |hr|
    #       FactoryGirl.create(:burn_up, user_profile: user_profile, timestamp: beginning_of_current_iteration + hr.hours)
    #     end
    #   end
    #   it { should have_content 'No burn up data'}
    # end
  end
end