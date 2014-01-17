require 'csv'
require 'spec_helper'
require_relative 'json_data'

include JsonData

module Trello
  describe Trello::Board do
    let(:card_json) { JSON.parse(card_json_string) }
    let(:card) { Card.new(card_json) }
    let(:board) { Board.new([card_json, card_json]) }
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
    
      context "with header" do
        its(:first) { should == Card.array_attributes.join(',')  }
      end
      
      context "of cards" do
        its(:last) { should == CSV.generate {|csv| csv << card.to_array }.chop }
      end
    end
  end
end
