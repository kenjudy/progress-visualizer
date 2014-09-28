require 'spec_helper'

describe ConcernsHelper, type: :helper do
  let(:request) { double("Request", fullpath: homepage_path).as_null_object }
  
  context "board label" do
    let(:user_profile) { nil }
    subject { board_label }
    it { is_expected.to eq '' }

    context "valid user_profile" do
      let(:user_profile) { FactoryGirl.build(:user_profile) }
      
      it { is_expected.to eq ' for ProgressVisualizer Board'}
      context "prefix passed as argument" do
        subject { board_label('on') }
        it { is_expected.to eq ' on ProgressVisualizer Board'}
      end
      
      context "shared report" do
        before { @share = FactoryGirl.build(:report_sharing, user_profile: FactoryGirl.build(:user_profile, name: 'Other')) }
        it { is_expected.to eq ' for Other Board'}
      end
    end
  end
end