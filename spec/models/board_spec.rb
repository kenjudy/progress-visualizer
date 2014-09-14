require 'csv'
require 'spec_helper'
require 'json'

describe Board, :type => :model do

  let(:user_profile) { FactoryGirl.create(:user_profile)}
  let(:list) { FactoryGirl.build(:list) }
  let(:card) { FactoryGirl.build(:card) }
  let(:board) { Board.new(lists: [list.data], cards: [card.data]) }

  subject { board }

  context "attributes" do
    its(:title) { should == "Current Sprint" }
  end

  context "accepts parsed json" do
    its(:data) { should eql({cards: [card.data], lists: [list.data]}) }
  end

  context "assigns list to cards" do
    subject { board.cards.first.list }
    its(:id) { should == list.data["id"] }
  end

  context "outputs to array" do
    before { card.list = list}
    subject { board.to_array }
  
    it { is_expected.to eq([card.to_array]) }
  end

  context "exports csv" do
    subject { board.to_csv.split("\n") }

    it { is_expected.to have(2).items }

    context "with header" do
      its(:first) { should == Card.array_attributes.join(',')  }
    end

    context "of cards" do
      before { card.list = list}
      its(:last) { should == CSV.generate {|csv| csv << card.to_array }.chop }
    end
  end
  
  context "find" do

    subject do
      VCR.use_cassette('models/board') do
        Board.find_by(user_profile: user_profile)
      end
    end

    its(:lists) { should have_at_least(1).item}
    its(:cards) { should have_at_least(1).item}

    context "request_board with archived cards" do
      subject do
        VCR.use_cassette('models/board_archived_cards') do
          Board.find_by(user_profile: user_profile, include_archived: true)
        end
      end
      its(:cards) { should have_at_least(1).item}
    end
  end

end