require 'spec_helper'

describe ReportSharing, :type => :model do
  
  subject { FactoryGirl.build(:report_sharing) }
  
  it { is_expected.to be_valid }
  its(:guid) { should_not be_nil }
  
  context "validations" do
    context "expiration" do
      subject { FactoryGirl.build(:report_sharing, expiration: nil) }
      it { is_expected.not_to be_valid }
    end
    context "url" do
      subject { FactoryGirl.build(:report_sharing, url: nil) }
      it { is_expected.not_to be_valid }
    end
    context "guid" do
      subject { FactoryGirl.build(:report_sharing, guid: nil) }
      it { is_expected.not_to be_valid }
    end
  end
end
