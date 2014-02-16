require 'spec_helper'

describe IterationConcern do
  include IterationConcern

  let(:user_profile) { FactoryGirl.create(:user_profile) }
  context "end_of_current_iteration" do
    subject { end_of_current_iteration }
    it { should == Time.zone.local_to_utc(Date.today.end_of_week.to_datetime - (7 - user_profile.end_day_of_week - 8).days +  user_profile.end_hour.hours) }
  end
  context "beginning_of_current_iteration" do
    subject { beginning_of_current_iteration }
    it { should == Time.zone.local_to_utc(Date.today.end_of_week.to_datetime - (7 - user_profile.start_day_of_week).days +  user_profile.start_hour.hours) }
  end
end