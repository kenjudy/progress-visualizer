require 'spec_helper'

describe TodoStory, :type => :model do
  let(:user_profile) { FactoryGirl.create(:user_profile) }
  let(:date) { Date.today }
  subject { TodoStory.new(timestamp: date, iteration: date, type_of_work: "Committed", status: "ToDo", story: "Story name", estimate: 3.0, user_profile: user_profile) }

  its(:timestamp) { date }
  its(:iteration) { date }
  its(:type_of_work) { "Committed" }
  its(:status) { "ToDo" }
  its(:story) { "Story name" }
  its(:estimate) { 3.0 }
  its(:user_profile) { user_profile }

end
