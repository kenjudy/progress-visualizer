require 'spec_helper'

describe UserProfilesController do

  let(:profile) { FactoryGirl.create(:user_profile) }
  let(:user) { profile.user }
  let(:user_id) { user.id }
  let(:profile_new) { FactoryGirl.build(:user_profile, user: user) }
  let(:profile_partial) { {"name" => profile_new.name, "default" => "1", "readonly_token" => profile_new.readonly_token, "current_sprint_board_id_short" => profile_new.current_sprint_board_id_short, "user_id" => user_id} }

  { index: :get, show: :get,
    new: :get, edit: :get,
    destroy: :delete }.each do |action, method|

    context "#{action} " do
      subject { send(method, action, id: profile.id, user_profile: profile_partial) }

      context "unauthenticated" do
        its(:code) { should == "302" }
      end
    end
  end

  context 'update' do
    let(:full_profile) { profile_partial.merge("done_lists" => "Done", "backlog_lists" => "To Do", "labels_types_of_work" => "Committed,Contingent", "duration" => "7", "start_day_of_week" => "0", "end_day_of_week" => "6", "start_hour" => "6", "end_hour" => "23") }

    before do
      sign_in user
      full_profile.delete("user_id")
      VCR.use_cassette('controllers/user_profiles_controller/update') do
        put :update, id: profile.id, user_profile: full_profile
      end
    end
    context "model" do
      subject { UserProfile.last }
      its(:done_lists) { should == {"52e6778d5922b7e16a641e5b" => "Done"}.to_json }
      its(:backlog_lists) { should == {"52e6778d5922b7e16a641e59"=>"To Do"}.to_json}
    end
    context "webhook" do
      subject { Webhook.last }
      its(:user_profile_id) {should == profile.id}
    end
  end
  context "update model different than current" do
    let(:full_profile) { profile_partial.merge("done_lists" => "Done", "backlog_lists" => "To Do", "labels_types_of_work" => "Committed,Contingent", "duration" => "7", "start_day_of_week" => "0", "end_day_of_week" => "6", "start_hour" => "6", "end_hour" => "23") }
    let(:current_profile) { FactoryGirl.create(:user_profile, user: user, labels_types_of_work: "Sample,Types") }
    before do
      sign_in user
      full_profile.delete("user_id")
      controller.stub(user_profile: current_profile)
      VCR.use_cassette('controllers/user_profiles_controller/update') do
        put :update, id: profile.id, user_profile: full_profile
      end
    end

    subject { UserProfile.find(current_profile.id) }
    its(:labels_types_of_work) { should == "Sample,Types" }
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

  # context "destroy" do
  #   let(:id) { profile.id }
  #   subject {delete :destroy, id: id}
  #
  #   context "destroys profile" do
  #     before { subject }
  #     it { expect{ UserProfile.find(id)}.to raise_error(ActiveRecord::RecordNotFound) }
  #   end
  # end

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
        before do
          VCR.use_cassette("controllers/user_profiles_controller/#{action.to_s}") do
            get action, id: profile.id
          end
        end
        it("assigns profile") { expect(assigns(:profile)).to eq profile }
      end
    end

    context "edit" do
      before do
        VCR.use_cassette('controllers/user_profiles_controller/edit') do
          get :edit, id: profile.id
        end
      end

      it("assings lists") { expect(assigns(:lists)).to have(4).items }
    end


    context "destroy" do
      let(:id) { profile.id }
      before { delete :destroy, id: id }

      it("destroys profile") { expect{ UserProfile.find(id)}.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  context "keys_from_values" do
    let(:lists) { [::ProgressVisualizerTrello::List.new({"id" => "ADSFSDF", "name" => "Done"}), ::ProgressVisualizerTrello::List.new({"id" => "FHGSDFG", "name" => "ToDo"})] }
    subject { controller.keys_from_values(lists, "Done,ToDo") }

    it { should == {"ADSFSDF" => "Done","FHGSDFG" => "ToDo"}.to_json }
  end
 end