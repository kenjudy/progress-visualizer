require 'spec_helper'

describe IterationConcern do
  include IterationConcern

  context "assign_user_profile" do
    let(:profile) { FactoryGirl.create(:user_profile, default: "0") }
    let(:profile2) { FactoryGirl.create(:user_profile, user: profile.user, default: "1" ) }
    let(:current_user) { profile.user }
    let(:params) { {} }
    
    before do
      profile2
      assign_user_profile
    end
    subject { user_profile }
    
    it { should == current_user.default_profile }
    
    context "passed by param" do
      before { params["profile_id"] = profile.id }

      it { should == user_profile }
      
    end
  end
end