require 'spec_helper'

describe UserProfileConcern do
  include UserProfileConcern
  include Rails.application.routes.url_helpers
  
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
  
  context "no user_profile" do
    before { user_profile = current_user }
    subject { assign_user_profile }
    
    it { expect(subject).to_not raise_error }
    
    context "bad session with default" do
      before { profile2 }
      before { session[:profile_id] = 6 }
      it { expect(subject).to_not raise_error }
      it { should == profile2 }
    end
    
    context "bad session no default" do
      before { profile }
      it { should == profile }
    end
    
    context "bad user_profile_id param" do
      before { params[:profile_id] = 6 }
      it { expect(subject).to_not raise_error }
    end
  end
end