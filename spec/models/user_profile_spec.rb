require 'spec_helper'

describe UserProfile, :type => :model do

  context "encrypted attributes" do
    [:readonly_token, :current_sprint_board_id,
     :current_sprint_board_id_short, :backlog_lists,
     :done_lists].each do |attribute|
       let(:up) { FactoryGirl.create(:user_profile) }
       let(:user) { up.user }

       context attribute.to_s do
         subject do
           up.user = user
           up.send("#{attribute}=", "foo")
           up.save
           UserProfile.find(up.id)
         end

         its("#{attribute}".to_sym) { should == "foo" }
         its("encrypted_#{attribute}".to_sym) { should_not be_nil }
         its("encrypted_#{attribute}_salt".to_sym) { should_not be_nil }
         its("encrypted_#{attribute}_iv".to_sym) { should_not be_nil }
       end

     end
  end

  context "default values" do
    before { FactoryGirl.create(:user_profile, backlog_lists: nil, done_lists: nil, duration: nil) }

    subject { UserProfile.first }

    its(:backlog_lists) { should == "{}"}
    its(:done_lists) { should == "{}"}
    its(:duration) { should == 7}
  end
  
  context "array_attributes" do
    subject { UserProfile.array_attributes }
    it { is_expected.to eq(%w(id user_id name default readonly_token current_sprint_board_id current_sprint_board_id_short backlog_lists done_lists labels_types_of_work duration start_day_of_week end_day_of_week start_hour end_hour created_at updated_at start_date)) }
  end
  
  context "to_csv" do
    let(:user_profile) { FactoryGirl.create(:user_profile) }
    let(:done_stories) { [FactoryGirl.create(:done_story, user_profile: user_profile)] }
    let(:burn_ups) { [FactoryGirl.create(:burn_up, user_profile: user_profile)] }

    before do
      done_stories
      burn_ups
    end

    subject { user_profile.to_csv }

    context "user_profile" do
      it { is_expected.to include("id,user_id,name,default,readonly_token,current_sprint_board_id,current_sprint_board_id_short,backlog_lists,done_lists,labels_types_of_work,duration,start_day_of_week,end_day_of_week,start_hour,end_hour,created_at,updated_at,start_date") }
      it { is_expected.to  match(/\d+,\d+,ProgressVisualizer,1,6b6fe08bec7db2ccd331954b03a7800458fdb5732cd87f5defb0493021861d39,52e6778d5922b7e16a641e58,WWtHBRod,\"{\"\"52e6778d5922b7e16a641e59\"\":\"\"To Do\"\",\"\"52e6778d5922b7e16a641e5a\"\":\"\"Doing\"\"}\",\"{\"\"52e6778d5922b7e16a641e5b\"\":\"\"Done\"\"}\",red,7,1,0,9,0,\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4},\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4},/) }
    end

    context "done_stories" do
      it { is_expected.to include("id,timestamp,iteration,type_of_work,status,story_id,story,estimate,created_at,updated_at,user_profile_id") }
      it { is_expected.to  match(/\d+,\d{4}-\d{2}-\d{2},\d{4}-\d{2}-\d{2},Committed,This Sprint - Pending Deploy,\d+,Story name,1.0,\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4},\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4},\d+/) }
    end

    context "burn_ups" do
      it { is_expected.to include("id,timestamp,backlog,done,backlog_estimates,done_estimates,created_at,updated_at,user_profile_id") }
      it { is_expected.to match(/\d+,\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4},16,4,35.0,11.5,\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4},\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4},\d+/) }
    end
  end
end