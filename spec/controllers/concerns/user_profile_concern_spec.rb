require 'spec_helper'

describe UserProfileConcern do
  include UserProfileConcern
  
  let(:profile) { FactoryGirl.create(:user_profile, default: "0") }
  let(:current_user) { profile.user }
  let(:profile2) { FactoryGirl.create(:user_profile, user: current_user, default: "1") }
  let(:session) { { user_profile: profile.id } }
  
  # context "assign_user_profile" do
  #   before do
  #     profile
  #     profile2
  #   end
  #   
  #   subject { assign_user_profile }
  #   
  #   context 'by params' do
  #     before { params = {id_profile: profile.id} }
  #     its(:id) { should == profile.id }
  #   end      
  #   
  #   context 'by session' do
  #     before { session[:user_profile] = profile.id }
  #     its(:id) { should == profile.id }
  #   end      
  # 
  #   context 'by defaults' do
  #     its(:id) { should == profile2.id }
  #   end      
  #   
  #   context 'no params hash' do
  #     let (:params) { nil }
  #     it(:id) { should == profile2.id }
  #   end      
  # end
  
end