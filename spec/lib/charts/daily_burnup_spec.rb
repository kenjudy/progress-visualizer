require 'spec_helper'

require_relative '../../models/trello/json_data'

include JsonData

module Charts
  describe DailyBurnup do
    let(:current_time) { Time.now }
    let(:card_data) { JSON.parse(card_json_string) }
    let(:card) { ::Trello::Card.new(card_data) }
    let(:board) { ::Trello::Board.new([card_data,card_data.merge({"idList" => "done1"})])}
    let(:ready_for_development) { ::Trello::List.new(JSON.parse(list_json_string))}
    let(:ready_for_signoff) { ::Trello::List.new({"id" => "signoff1", "name" => "Ready for Signoff"})}
    let(:done) { ::Trello::List.new({"id" => "done1", "name" => "Done"})}
    let(:options) { {done_lists: [done, ready_for_signoff], backlog_lists: [ready_for_development,done, ready_for_signoff], timestamp: current_time} }
    subject { DailyBurnup.new(board, options) }
    
    its(:done_lists) { should == [done, ready_for_signoff] }
    its(:backlog_lists) { should == [ready_for_development,done, ready_for_signoff] }
    its(:timestamp) { should eql(current_time) }
     
    context "assigned" do
      before do
        subject.done_lists = [done,]
        subject.backlog_lists = [ready_for_development,done]
        subject.timestamp = Date.new(2014,1,1)
      end
    
      its(:done_lists) { should == [done] }
      its(:backlog_lists) { should == [ready_for_development,done] }
      its(:timestamp) { should == Date.new(2014,1,1) }
    end
    
    context "defaults" do
      let(:current_time) { nil }
      its(:timestamp) { should_not be_nil }
    end
        
    its(:current_progress) { should eql({timestamp: subject.timestamp, backlog: 5.0, done: 2.5}) }
    
  end
end
