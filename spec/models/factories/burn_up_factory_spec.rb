require 'spec_helper'


describe Factories::BurnUpFactory do

  let(:profile) { FactoryGirl.build(:user_profile) }
  let(:adapter) { ::TrelloAdapter.new(profile) }
  let(:done_lists) { JSON.parse(profile.done_lists) }
  let(:backlog_lists) { JSON.parse(profile.backlog_lists) }

  let(:board) { profile.current_sprint_board_id }

  let(:burn_up_factory) { Factories::BurnUpFactory.new(profile) }

  subject { burn_up_factory }

  its(:done_lists) { should == done_lists }
  its(:backlog_lists) { should ==  backlog_lists }
  its(:timestamp) { should be_instance_of(Time) }

  context "assigned" do
    its(:done_lists) { should == done_lists }
    its(:backlog_lists) { should == backlog_lists }
    its(:timestamp) { should be_instance_of(Time) }
  end

  context "defaults" do
    let(:current_time) { nil }
    its(:timestamp) { should be_instance_of(Time) }
  end

  context "update" do
    after do
      VCR.use_cassette('controllers/concerns/charts/burn_up_factory') do
        subject.update
      end
    end

    it { expect(BurnUp).to receive(:create).with({:user_profile=> profile, :timestamp=>anything, :done=>anything, :done_estimates=>anything, :backlog=>anything, :backlog_estimates=>anything})}
  end

  context "redundant?" do
    let(:timestamp) { Time.now - 1.hours + 58.minutes }
    let(:backlog) { 2 }
    let(:done_stats) {{ count: 1, sum: 2.5 }}
    let(:backlog_stats) {{ count: 2, sum: 5.0 }}

    before { profile.burn_ups << FactoryGirl.build(:burn_up, {user_profile: profile, timestamp: timestamp, backlog: backlog, done: 1, backlog_estimates: 5.0, done_estimates: 2.5}) }

    subject { burn_up_factory.redundant?(done_stats, backlog_stats) }

    it { should be_true }

    context "different stats" do
      let(:backlog) { 3 }
      it { should be_false }
    end
    context "old timestamp" do
      let(:timestamp) { Time.now - 7.hours }
      it { should be_false }
    end
  end


end
