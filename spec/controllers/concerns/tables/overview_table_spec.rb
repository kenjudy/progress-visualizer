require 'spec_helper'

describe Tables::OverviewTable do
  include Trello::JsonData

  let(:board) { Trello::Board.new(lists: [example_list_data], cards: [example_card_data]) }
  let(:adapter) { Adpaters::TrelloAdapter }

  before { adapter.stub(request_board: board) }

  context "current" do
    subject { Tables::OverviewTable.current }
    #it { should == nil }
  end

  context "update" do
    
    
 #   after { Tables::OverviewTable.update(adapter) }
    
#    it("should create done story") { expect_any_instance_of(DoneStory).to receive(:update_attributes).with() }
  end
end
