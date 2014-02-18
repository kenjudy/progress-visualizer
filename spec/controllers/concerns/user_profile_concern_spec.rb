require 'spec_helper'

describe UserProfileConcern do
  include UserProfileConcern
  
  let(:profile) { FactoryGirl.create(:user_profile, default: "0") }
  let(:current_user) { profile.user }
  let(:profile2) { FactoryGirl.create(:user_profile, user: profile.user, default: "1") }
  
  def params
    @params ||= {}
  end
  
  context "assign_user_profile" do
    before do
      profile
      profile2
    end
    
    subject { assign_user_profile }
    
    context 'by params' do
      before { params[:profile_id] = profile.id }
      its(:id) { should == profile.id }
    end      
    
    context 'by session' do
      before { session[:profile_id] = profile.id }
      its(:id) { should == profile.id }
    end      
  
    context 'by defaults' do
      its(:id) { should == profile2.id }
    end      
    
    context 'no params hash' do
      its(:id) { should == profile2.id }
    end
    
    context "nil current user" do
      let(:current_user) { nil }
      it { should be_nil }
    end
  end
  
end