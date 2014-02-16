require 'spec_helper'

describe WebhooksController do
  
  context "burn_up" do
    let(:user_profile) { FactoryGirl.create(:user_profile) }
    let(:burnup_chart) { double(Charts::BurnUpChart).as_null_object }
  
    before { Charts::BurnUpChart.stub(current: burnup_chart) }
  
    subject { post :burn_up, profile_id: user_profile.id, format: "json" }
  
    its(:code) { should == "200" }
    its(:body) { should == "OK" }
    
    context "burnup data" do
      after { subject }
  
      it("updates") { expect(burnup_chart).to receive(:update).once }
      
    end
    
  end
end
