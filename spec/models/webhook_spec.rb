require 'spec_helper'

describe Webhook, :type => :model do
  let(:user_profile) { FactoryGirl.create(:user_profile)}
  let(:webhook) do
    VCR.use_cassette('models/add_webhook') do
      FactoryGirl.create(:webhook, user_profile: user_profile)
    end
  end

  subject { webhook }

  its(:external_id) { should_not be_nil }
  its(:description) { should == "Joe Foo ProgressVisualizer burnup" }
  its(:id_model) { should_not be_nil }
  its(:callback_url) { should_not be_nil }
  
  context "validation" do
    before { webhook }
    it("fails") { expect{ FactoryGirl.create(:webhook, user_profile: user_profile) }.to raise_error(ActiveRecord::RecordInvalid)}
  end
  
  context "destroy" do
    subject do
      VCR.use_cassette('models/destroy_webhook') do
        webhook.destroy
      end
    end
    it { is_expected.to be_truthy }
  end
end