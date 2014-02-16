require 'spec_helper'

describe UserProfilesHelper do
  let(:field) { "{\"5170058469d58225070003cc\":\"Ready for Development\",\"5170058469d58225070003cd\":\"In Progress\",\"51e44c8a29ef12da5d00028c\":\"Ready for QA\",\"520a5526d0aa033e6f00244e\":\"In QA\"}" }
  let(:user_profile) { FactoryGirl.build(:user_profile) }
  context "display_values" do
    subject { display_keys(field) }
    it {should == "Ready for Development,In Progress,Ready for QA,In QA"}
    context "list" do
      subject { display_keys("Test,Label")}
      it{should=="Test,Label"}
    end
    context "blank" do
      subject { display_keys(nil)}
      it { should== ""}
    end
  end
  
  context "request_token_url" do
    before { @profile = user_profile }
    subject { request_token_url }
    it { should == "https://trello.com/1/authorize?key=c4ba8f697ddf1843e4ef0b84fc3aff98&name=ProgressVisualizer&expiration=never&response_type=token"}
  end
end