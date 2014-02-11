require 'spec_helper'

describe UserProfilesController do
  let(:profile) { FactoryGirl.create(:user_profile) }
  let(:params) { {
    name: profile.name,
    default: profile.default,
    readonly_token: profile.readonly_token,
    current_sprint_board_id: profile.current_sprint_board_id,
    current_sprint_board_id_short: profile.current_sprint_board_id_short,
    backlog_lists: profile.backlog_lists,
    done_lists: profile.done_lists,
    labels_types_of_work: profile.labels_types_of_work,
    duration: profile.duration,
    start_day_of_week: profile.start_day_of_week,
    end_day_of_week: profile.end_day_of_week,
    start_hour: profile.start_hour,
    end_hour: profile.end_hour,
    user_id: profile.user.id 
    }   }
  
  { index: :get, show: :get, 
    new: :get, edit: :get,
    create: :post, update: :put,
    destroy: :delete }.each do |action, method|
      
    context action do
      subject { send(method, action, id: profile.id) }
      
      its(:code) { should == "302" }

      context "authenticated" do
        before { sign_in profile.user }
        its(:code) { should == "200" }
      end
    end
    
  end
  
  context "assigns" do
    before { sign_in profile.user }

    context "index" do
      before { get :index }
      it("assigns profiles"){ expect(assigns(:profiles)).to eq profile.user.user_profiles }
    end

    context "new" do
      before { get :new }
      it("assigns profile"){ expect(assigns(:profile)).to_not be_nil }
    end
    
    [:show, :edit].each do |action|
      context action do
        before { get action, id: profile.id }
        it("assigns profile") { expect(assigns(:profile)).to eq profile }
      end
    end
    
    context "destroy" do
      let(:id) { profile.id }
      before { delete :destroy, id: id }
      it("destroys profile") { expect{ UserProfile.find(id)}.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end