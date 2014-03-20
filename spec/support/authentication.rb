require 'spec_helper'

include Warden::Test::Helpers

def authenticate
  user_profile = FactoryGirl.create(:user_profile)
  login_as(user_profile.user, :scope => :user)
end

RSpec.configure do |config|
  config.before(:each) do
    Warden.test_mode!  if example.metadata[:type] == :feature
  end
  
  config.after(:each) do
    Warden.test_reset! if example.metadata[:type] == :feature
  end
end  
