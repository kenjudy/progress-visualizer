require 'spec_helper'

describe UserProfilesController do
  include IterationConcern
  
  let(:profile) { FactoryGirl.create(:user_profile) }
  let(:user) { profile.user }
  let(:user_id) { user.id }
  let(:profile_partial) { { "name" => "Current Sprint", "default" => "1", "readonly_token" => "test0token", "current_sprint_board_id_short" => "ZoCdRXWT", "user_id" => user_id } }
  let(:list) { { list: "foo" } }
  before { adapter.stub(request_lists: [list]) }
  
  { index: :get, show: :get, 
    new: :get, edit: :get,
    update: :put, destroy: :delete }.each do |action, method|
      
    context "#{action} " do
      subject { send(method, action, id: profile.id, user_profile: profile_partial) }
      
      context "unauthenticated" do 
        its(:code) { should == "302" }
      end

      context "authenticated" do
        before { sign_in profile.user }
        its(:code) { should == "200" }
      end
    end       
  end

   
  context "create" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    subject { post :create, user_profile: profile_partial }
    
    it("saves profile") do
      subject
      expect(user.reload.user_profiles).to_not be_empty
    end
    
    context "replaces old default" do
      let(:older_profile) { UserProfile.create(user: user, name: "old", default: "1") }
    
      before do
        older_profile
        post :create, user_profile: profile_partial
      end
      
      subject { user.user_profiles.find_by(name: "old") }
      
      its(:default) { should == "0" }
      
    end
  end
  
  context "assignment" do
    before { sign_in profile.user }

    context "index" do
      before { get :index }
      it("assigns profiles"){ expect(assigns(:profiles)).to eq profile.user.user_profiles }
    end

    context "new" do
      before do 
        profile.destroy!
        get :new
      end
      it("assigns profile"){ expect(assigns(:profile)).to_not be_nil }
      it("sets default"){ expect(assigns(:profile).default).to eq("1") }
    end
    
    [:show, :edit].each do |action|
      context action do
        before { get action, id: profile.id }
        it("assigns profile") { expect(assigns(:profile)).to eq profile }
      end
    end

    context "edit" do
      before { get :edit, id: profile.id }
      it("assings lists") { expect(assigns(:lists)).to eq [list] }
    end
    
    
    context "destroy" do
      let(:id) { profile.id }
      before { delete :destroy, id: id }
      
      it("destroys profile") { expect{ UserProfile.find(id)}.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
  
 end