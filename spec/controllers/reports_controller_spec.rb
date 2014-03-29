require 'spec_helper'

describe ReportsController do

  let(:user_profile) { FactoryGirl.create(:user_profile)}

  context "performance summary" do
    context "not authenticated" do
      subject { get :performance_summary }

      its(:code) { should == "302" }

    end

    context "authenticated" do
      before { sign_in user_profile.user }
      let(:iteration) { nil }

      subject do
        VCR.use_cassette('controllers/reports_controller') do
          get :performance_summary, iteration: iteration
        end
      end

      its(:code) { should == "200" }

      context "optional date param" do
        let(:iteration) { "2014-03-04" }
        before { expect_any_instance_of(Factories::DoneStoryFactory).to receive(:for_iteration).with(iteration) }
        it("retrieves done stories for iteration") { subject }
      end
    end
  end
  
  context "sharing" do
    let(:expiration) { Time.now + 2.weeks }
    let(:report_sharing) { FactoryGirl.create(:report_sharing, user_profile: user_profile, expiration: expiration) }
    subject { get :sharing, guid: report_sharing.guid }
    
    its(:code) { should == "200" }
    
    context "expired share" do
      let(:expiration) { Time.now - 1.day }
      its(:code) { should == "410"}
    end
  end

end