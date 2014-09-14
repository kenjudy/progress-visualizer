require 'spec_helper'

describe UserProfilesHelper, type: :helper do
  let(:field) { "{\"5170058469d58225070003cc\":\"Ready for Development\",\"5170058469d58225070003cd\":\"In Progress\",\"51e44c8a29ef12da5d00028c\":\"Ready for QA\",\"520a5526d0aa033e6f00244e\":\"In QA\"}" }
  let(:user_profile) { FactoryGirl.build(:user_profile) }
  context "display_values" do
    subject { display_keys(field) }
    it {is_expected.to eq("Ready for Development,In Progress,Ready for QA,In QA")}
    context "list" do
      subject { display_keys("Test,Label")}
      it{is_expected.to eq("Test,Label")}
    end
    context "blank" do
      subject { display_keys(nil)}
      it { is_expected.to eq("")}
    end
  end

  context "request_token_url" do
    before { @profile = user_profile }
    subject { request_token_url }
    it { is_expected.to eq("https://trello.com/1/authorize?key=c4ba8f697ddf1843e4ef0b84fc3aff98&name=ProgressVisualizer&expiration=never&response_type=token")}
  end
  
  context "options_for_day_of_week" do
    subject { options_for_day_of_week(6) }
    it { is_expected.to eq("<option value=\"0\">Sunday</option>\n<option value=\"1\">Monday</option>\n<option value=\"2\">Tuesday</option>\n<option value=\"3\">Wednesday</option>\n<option value=\"4\">Thursday</option>\n<option value=\"5\">Friday</option>\n<option selected=\"selected\" value=\"6\">Saturday</option>") }
  end

  context "options_for_duration" do
    subject { options_for_duration(14) }
    it { is_expected.to eq("<option value=\"7\">One week</option>\n<option selected=\"selected\" value=\"14\">Two weeks</option>\n<option value=\"21\">Three weeks</option>\n<option value=\"28\">Four weeks</option>") }
  end
end