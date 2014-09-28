require 'spec_helper'

describe ContactFormHelper, type: :helper do
  context "options_for_type_of_inquiry" do
    subject { options_for_type_of_inquiry("Question") }
    it { is_expected.to eq("<option value=\"Help\">Help</option>\n<option selected=\"selected\" value=\"Question\">Question</option>\n<option value=\"Suggestion\">Suggestion</option>\n<option value=\"Other\">Other</option>") }
  end
  
  context 'form defaults from user profile' do
    let(:user_profile) { nil }
    
    context "user_name" do
      subject { user_name }
      it { is_expected.to be_nil }
      context "user is authenticated" do
        let(:user_profile) { FactoryGirl.create(:user_profile)}
        it { is_expected.to eq 'Joe Foo' }
      end
    end

    context "user_email" do
      subject { user_email }
      it { is_expected.to be_nil }
      context "user is authenticated" do
        let(:user_profile) { FactoryGirl.create(:user_profile)}
        it { is_expected.to eq 'joe.foo@blarg.org' }
      end
    end
  end
end
