require 'spec_helper'

describe ConcernsHelper, type: :helper do
  include ActionView::Helpers::TextHelper
  
  let(:request) { double("Request", fullpath: homepage_path).as_null_object }
  
  context "board label" do
    let(:user_profile) { nil }
    subject { board_label('on') }
    it { is_expected.to eq '' }

    context "valid user_profile" do
      let(:user_profile) { FactoryGirl.build(:user_profile) }
      subject { board_label('on') }
      it { is_expected.to eq ' on ProgressVisualizer Board'}
      
      context "shared report" do
        before { @share = FactoryGirl.build(:report_sharing, user_profile: FactoryGirl.build(:user_profile, name: 'Other')) }
        it { is_expected.to eq ' on Other Board'}
      end
      
      context "passed multiple profiles" do
        subject { board_label('on', [double('UserProfile', name: 'Board1'), double('UserProfile', name: 'Board2')]) }
        it { is_expected.to eq ' on All Boards'}
      end
    end
  end
end