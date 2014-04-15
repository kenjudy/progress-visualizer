require 'spec_helper'
require 'json'

module ProgressVisualizerTrello
  describe ProgressVisualizerTrello::List do
    include JsonData

    subject { List.new(example_list_data)}

    its(:id) { should == "52653272e6fa31217b001705" }
    its(:name) { should == "Ready for Development" }

    context "find_by" do
      let(:user_profile) { FactoryGirl.create(:user_profile)}
      subject do
        VCR.use_cassette('models/lists_find_by') do
          List.find_by(user_profile: user_profile)
        end
      end
      
      it { should have_at_least(1).item }
      its(:first) { should be_instance_of(List)}
    end

  end
end