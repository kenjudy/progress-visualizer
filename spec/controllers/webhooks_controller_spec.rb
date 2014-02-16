require 'spec_helper'

describe WebhooksController do
  
  context "burn_up" do
    let(:user_profile) { FactoryGirl.create(:user_profile) }
  
    subject do
      VCR.use_cassette('controllers/controllers/webhooks_controller') do
        post :burn_up, profile_id: user_profile.id, format: "json"
      end
    end
  
    its(:code) { should == "200" }
    its(:body) { should == "OK" }
    
    context "burnup data" do
      after { subject }
  
      it("updates") { expect_any_instance_of(Charts::BurnUpChart).to receive(:update).once }
      
    end
    
  end
end
