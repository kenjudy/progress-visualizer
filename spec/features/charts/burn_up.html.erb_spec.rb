require 'spec_helper'

include Warden::Test::Helpers

describe "burn_up", type:  :feature, js: true do
  before { visit '/chart/burn-up' }

  subject { page }
  
  context "login prompt" do
    it { should have_content 'Sign in' }
  end
  
  context "authenticated" do
    before do
      Warden.test_mode!
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :user)
    end
    
    after { Warden.test_reset! }
    
    it { pending("devise capybara poltergeist");should have_content 'No burn up data'}
  end
end