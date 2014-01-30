require 'spec_helper'


module Charts
  describe DailyBurnup do
    include Trello::JsonData

    let(:current_time) { Time.now }
    let(:card_data) { example_card_data }
    let(:card) { ::Trello::Card.new(card_data) }
    let(:board) { ::Trello::Board.new({cards: [card_data,card_data.merge({"idList" => "done1"})], lists: []})}
    let(:ready_for_development) { ::Trello::List.new(example_list_data)}
    let(:ready_for_signoff) { ::Trello::List.new({"id" => "signoff1", "name" => "Ready for Signoff"})}
    let(:done) { ::Trello::List.new({"id" => "done1", "name" => "Done"})}
    let(:options) { {done_list_ids: [done.id, ready_for_signoff.id], backlog_list_ids: [ready_for_development.id,done.id, ready_for_signoff.id], timestamp: current_time} }

    subject { DailyBurnup.new(board, options) }
    
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
        
    context "update_progress" do
      after { subject.update_progress }

      it { expect(BurnUp).to receive(:create).with({:timestamp=>current_time, :done=>1, :done_estimates=>2.5, :backlog=>2, :backlog_estimates=>5.0})}
    end
    
    context "current_burnup_data" do
      after { DailyBurnup.current_burnup_data }
      it { expect(DailyBurnup).to receive(:burnup_data).with(Date.today.end_of_week - 6.days, Date.today.end_of_week)}

    end
    
    context "cuurent burnup" do
      before { Adapters::TrelloAdapter.stub(request_board: board) }
      
      subject { DailyBurnup.current_burnup(Adapters::TrelloAdapter) }
      
      it { should be_instance_of(Charts::DailyBurnup) }
    end
    
  
    
  end
end
