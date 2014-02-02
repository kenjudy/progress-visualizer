require 'spec_helper'

describe UserMailer do
  
  context "forgot_password" do
    let(:user) { FactoryGirl.build(:user) }
    before { UserMailer.forgot_password(user, "randomlygeneratedpassword").deliver }
    after { ActionMailer::Base.deliveries = [] }
    subject  { ActionMailer::Base.deliveries.last }
    
    it { should_not eq user.email }
  end
end