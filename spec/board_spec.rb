require_relative '../app/board'
require_relative 'json_data'

include JsonData

describe TrelloReport::Board do
  let(:card_json) { JSON.parse(card_json_string) }
  let(:card) { TrelloReport::Card.new(card_json) }
  let(:board) { TrelloReport::Board.new([card_json, card_json]) }
  subject { board }
  
  context "accepts json" do
    its(:json) { should eql([card_json, card_json]) }
    its(:cards) { should have(2).items }
  end
  
  context "outputs to array" do
    subject { board.to_array }
    
    it { should == [card.to_array, card.to_array]}
  end
  
  context "exports csv" do
    subject { board.to_csv.split("\n") }
    
    it { should have(3).items }
    
    context "header" do
      its(:first) { should == TrelloReport::Card.array_attributes.join(',')  }
      its(:last) { should == card.to_array.join(',')}
    end
  end
end
