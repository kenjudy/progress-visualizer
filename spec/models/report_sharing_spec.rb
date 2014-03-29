require 'spec_helper'

describe ReportSharing do
  
  subject { FactoryGirl.build(:report_sharing) }
  
  it { should be_valid }
  
  context "validations" do
    context "expiration" do
      subject { FactoryGirl.build(:report_sharing, expiration: nil) }
      it { should_not be_valid }
    end
    context "url" do
      subject { FactoryGirl.build(:report_sharing, url: nil) }
      it { should_not be_valid }
    end
    context "guid" do
      subject { FactoryGirl.build(:report_sharing, guid: nil) }
      it { should_not be_valid }
    end
  end
end
