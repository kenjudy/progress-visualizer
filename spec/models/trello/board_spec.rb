require 'csv'
require 'spec_helper'
require_relative 'json_data'

include JsonData

module Trello
  describe Trello::Board do
    let(:card_data) { JSON.parse(card_json_string) }
    let(:card) { Card.new(card_data) }
    let(:board) { Board.new([card_data, card_data]) }
    
    subject { board }
    
    context "attributes" do
      its(:title) { should == "Current Sprint" }
    end
      
    context "accepts parsed json" do
      its(:data) { should eql([card_data, card_data]) }
      its(:cards) { should have(2).items }
    end
  
    context "outputs to array" do
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
        its(:last) { should == CSV.generate {|csv| csv << card.to_array }.chop }
      end
    end
  end
end
