require 'spec_helper'

describe "burn_up", type:  :feature, js: false do
  
  subject do
    visit '/chart/burn-up' 
    page
  end
  
  context "login prompt" do
    it { should have_content 'Sign in' }
  end
  
  context "authenticated" do
    before { authenticate }
    
    it { should have_content 'No burn up data'}
  end
end