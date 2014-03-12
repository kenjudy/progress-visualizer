require 'spec_helper'

describe ReportsController do

  let(:user_profile) { FactoryGirl.create(:user_profile)}

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
      before { subject }
      it { expect(assigns(:iteration)).to eql "2014-03-04" }
    end
  end
  
end