require 'spec_helper'

describe UserProfilesController do
  
  let(:profile) { FactoryGirl.create(:user_profile) }
  let(:user) { profile.user }
  let(:user_id) { user.id }
  let(:profile_partial) { { "name" => "Current Sprint", "default" => "1", "readonly_token" => "test0token", "current_sprint_board_id_short" => "ZoCdRXWT", "user_id" => user_id } }
  let(:lists) { [::ProgressVisualizerTrello::List.new({"id" => "ADSFSDF", "name" => "Done"}), ::ProgressVisualizerTrello::List.new({"id" => "FHGSDFG", "name" => "ToDo"})] }
  
  before do
    allow_any_instance_of(::Adapters::TrelloAdapter).to receive(:request_lists).and_return(lists)
    allow_any_instance_of(::Adapters::TrelloAdapter).to receive(:request_board_metadata).and_return({"labelNames" => { "blue" => "Work"}})
  end
  
  { index: :get, show: :get, 
    new: :get, edit: :get,
    destroy: :delete }.each do |action, method|
      
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
  
  context 'update' do
    before do
      sign_in user
      full_profile.delete("user_id")
    end
    let(:full_profile) { profile_partial.merge("done_lists" => "Done", "backlog_lists" => "ToDo", "labels_types_of_work" => "Committed,Contingent", "duration" => "WEEKLY", "start_day_of_week" => "0", "end_day_of_week" => "6", "start_hour" => "6", "end_hour" => "23") }
    after { put :update, id: profile.id, user_profile: full_profile }
    it("updates model") { expect_any_instance_of(UserProfile).to receive(:update_attributes).with(full_profile.merge("done_lists" => {"ADSFSDF" => "Done"}.to_json, "backlog_lists" => {"FHGSDFG" => "ToDo"}.to_json))}
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
      it("assings lists") { expect(assigns(:lists)).to eq lists }
    end
    
    
    context "destroy" do
      let(:id) { profile.id }
      before { delete :destroy, id: id }
      
      it("destroys profile") { expect{ UserProfile.find(id)}.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
  
  context "keys_from_values" do
    subject { controller.keys_from_values(lists, "Done,ToDo") }
    
    it { should == {"ADSFSDF" => "Done","FHGSDFG" => "ToDo"}.to_json }
  end
 end