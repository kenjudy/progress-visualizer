require 'spec_helper'

describe AdminController, type: :controller do
  let(:role) { 'admin' }
  let(:user) { FactoryGirl.create(:user, role: role)}
  let(:user_profile) { FactoryGirl.create(:user_profile, user: user) }
  before { sign_in user_profile.user }

  context "users" do
    subject { get :users }
    
    its(:code) { should == "200" }

    context "not admin" do
      let(:role) { 'user' }
      its(:code) { should == "403" }
    end

  end

  context "cards" do
    subject { get :cards }
    
    its(:code) { should == "200" }

    context "not admin" do
      let(:role) { 'user' }
      its(:code) { should == "403" }
    end

  end
end