require 'spec_helper'


module Charts
  describe BurnUpChart do
    include Trello::JsonData

    let(:current_time) { Time.now }
    let(:card_data) { example_card_data }
    let(:card) { ::Trello::Card.new(card_data) }
    let(:board) { ::Trello::Board.new({cards: [card_data,card_data.merge({"idList" => "done1"})], lists: []})}
    let(:ready_for_development) { ::Trello::List.new(example_list_data)}
    let(:ready_for_signoff) { ::Trello::List.new({"id" => "signoff1", "name" => "Ready for Signoff"})}
    let(:done) { ::Trello::List.new({"id" => "done1", "name" => "Done"})}
    let(:options) { {done_list_ids: [done.id, ready_for_signoff.id], backlog_list_ids: [ready_for_development.id,done.id, ready_for_signoff.id], timestamp: current_time} }

    subject { BurnUpChart.new(board, options) }
    
    its(:done_list_ids) { should == [done.id, ready_for_signoff.id] }
    its(:backlog_list_ids) { should == [ready_for_development.id,done.id, ready_for_signoff.id] }
    its(:timestamp) { should eql(current_time) }
     
    context "assigned" do
      before do
        subject.done_list_ids = [done.id,ready_for_signoff.id]
        subject.backlog_list_ids = [ready_for_development.id,done.id]
        subject.timestamp = Date.new(2014,1,1)
      end
    
      its(:done_list_ids) { should == [done.id, ready_for_signoff.id] }
      its(:backlog_list_ids) { should == [ready_for_development.id,done.id] }
      its(:timestamp) { should == Date.new(2014,1,1) }
    end
    
    context "defaults" do
      let(:current_time) { nil }
      its(:timestamp) { should_not be_nil }
    end
        
    context "update" do
      after { subject.update }

      it { expect(BurnUp).to receive(:create).with({:timestamp=>current_time, :done=>1, :done_estimates=>2.5, :backlog=>2, :backlog_estimates=>5.0})}
    end
    
    context "redundant?" do
      let(:timestamp) { Time.now - 3.hours }
      let(:backlog) { 2 }
      let(:done_stats) {{ count: 1, sum: 2.5 }}
      let(:backlog_stats) {{ count: 2, sum: 5.0 }}

      before { BurnUp.stub(last: FactoryGirl.build(:burn_up, {timestamp: timestamp, backlog: backlog, done: 1, backlog_estimates: 5.0, done_estimates: 2.5})) }
 
      subject { BurnUpChart.new(board, options).redundant?(done_stats, backlog_stats) }
      
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
    
    context "current burn_up chart" do
      before { Adapters::TrelloAdapter.stub(request_board: board) }
      
      subject { BurnUpChart.current(Adapters::TrelloAdapter) }
      
      it { should be_instance_of(Charts::BurnUpChart) }
    end
    
    context "current_burn_up_data" do
      after { BurnUpChart.current_burn_up_data }
      it { expect(BurnUp).to receive(:burn_up_data).with(BurnUpChart.beginning_of_current_iteration, BurnUpChart.end_of_current_iteration)}
    end
  
    
  end
end
