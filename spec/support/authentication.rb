require 'spec_helper'

shared_context "authentication" do
  include Warden::Test::Helpers

  def user_profile
    @user_profile ||= FactoryGirl.create(:user_profile)
  end

  def authenticate
    login_as(user_profile.user, :scope => :user)
  end

  before { Warden.test_mode! }
  after { Warden.test_reset! }

end
