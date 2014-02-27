require 'spec_helper'

describe ReportsController do
  include ProgressVisualizerTrello::JsonData

  let(:user_profile) { FactoryGirl.create(:user_profile)}

  context "not authenticated" do
    subject { get :performance_summary }

    its(:code) { should == "302" }

  end

  context "authenticated" do
    before { sign_in user_profile.user }

    subject do
      VCR.use_cassette('controllers/reports_controller') do
        get :performance_summary
      end
    end
  
    its(:code) { should == "200" }

  end
  
end