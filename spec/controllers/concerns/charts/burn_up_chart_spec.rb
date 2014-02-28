require 'spec_helper'


module Charts
  describe BurnUpChart do

    let(:profile) { FactoryGirl.build(:user_profile) }
    let(:adapter) { ::Adapters::TrelloAdapter.new(profile) }
    let(:done_lists) { JSON.parse(profile.done_lists) }
    let(:backlog_lists) { JSON.parse(profile.backlog_lists) }
    
    let(:board) { profile.current_sprint_board_id }
    
    let(:burn_up_chart) { BurnUpChart.new(profile) }
    
    subject { burn_up_chart }
    
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
        VCR.use_cassette('controllers/concerns/charts/burn_up_chart') do
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

      before { BurnUp.stub(last: FactoryGirl.build(:burn_up, {user_profile: profile, timestamp: timestamp, backlog: backlog, done: 1, backlog_estimates: 5.0, done_estimates: 2.5})) }
 
      subject { burn_up_chart.redundant?(done_stats, backlog_stats) }
      
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
    
    context "current" do
      subject { BurnUpChart.new(profile) }
      
      it { should be_instance_of(Charts::BurnUpChart) }
    end
    
     
  end
end
