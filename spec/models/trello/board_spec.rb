require 'csv'
require 'spec_helper'

module Trello
  describe Trello::Board do
    include JsonData

    let(:list_data) { example_list_data }
    let(:list) { List.new(list_data) }
    let(:card_data) { example_card_data({ "idList" => list_data["id"] }) }
    let(:card) { Card.new(card_data) }
    let(:board) { Board.new({cards: [card_data, card_data], lists: [list_data]}) }
    
    subject { board }
    
    context "attributes" do
      its(:title) { should == "Current Sprint" }
    end
      
    context "accepts parsed json" do
      its(:data) { should eql({cards: [card_data, card_data], lists: [list_data]}) }
      its(:cards) { should have(2).items }
      its(:lists) { should have(1).items }
    end
    
    context "assigns list to cards" do
      subject { board.cards.first.list }
      its(:id) { should == list_data["id"] }
    end
  
    context "outputs to array" do
      before { card.list = list}
      subject { board.to_array }
    
      it { should == [card.to_array, card.to_array]}
    end
  
    context "exports csv" do
      subject { board.to_csv.split("\n") }
    
      it { should have(3).items }
    
      context "with header" do
        its(:first) { should == Card.array_attributes.join(',')  }
      end
      
      context "of cards" do
        before { card.list = list}
        its(:last) { should == CSV.generate {|csv| csv << card.to_array }.chop }
      end
    end
  end
end
