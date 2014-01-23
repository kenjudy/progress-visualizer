require 'spec_helper'

require 'csv'

module Adapters
  describe TrelloAdapter do
    include Trello::JsonData
    
    let(:uri) { double(URI, read: "[{}]" ) }
    before do
      URI.stub(parse: uri)
      CSV.stub(open: [])
    end
    
    # context "daily burnup" do
    #   let(:card_data) { example_card_data }
    #   let(:card) { Trello::Card.new(card_data) }
    #   subject do
    #     board = TrelloAdapter.daily_burnup
    #     board.cards.first
    #   end
    #   
    #   before { TrelloAdapter.stub(request_cards: [card_data])}
    #   
    #   its(:id) { should == card.id }
    #   
    #   context "requests cards" do
    #     after { TrelloAdapter.daily_burnup }
    #     it { expect(TrelloAdapter).to receive(:request_cards).with(Trello::Constants::CURRENT_SPRINT_BOARD_ID)}
    #   end
    # end
    
    context "request_board" do
      let(:card_data) { example_card_data }
      let(:card) { Trello::Card.new(card_data) }
      let(:list_data) { example_list_data }
      let(:list) { Trell::List.new(list_data) }
      
      before do
        TrelloAdapter.stub(request_cards: [card_data])
        TrelloAdapter.stub(request_archived_cards: [card_data])
        TrelloAdapter.stub(request_lists: [list_data])
      end
      
      subject { TrelloAdapter.request_board(Trello::Constants::CURRENT_SPRINT_BOARD_ID) }
    
      its(:lists) { should have(1).item}
      its(:cards) { should have(1).item}
      
      context "request_board with archived cards" do
        subject { TrelloAdapter.request_board(Trello::Constants::CURRENT_SPRINT_BOARD_ID, true) }
        its(:cards) { should have(2).items}
      end
    end

    context "request_archived_cards" do
      subject { TrelloAdapter.request_archived_cards(Trello::Constants::CURRENT_SPRINT_BOARD_ID) }
    
      it { should == [{}] }

      context "url" do
        after { subject }
     
        it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{Trello::Constants::CURRENT_SPRINT_BOARD_ID}/cards/closed?key=#{Trello::Constants::USER_KEY}&token=#{Trello::Constants::READONLY_TOKEN}").and_return(uri) }
      end
    end
    
    context "request_cards" do
      subject { TrelloAdapter.request_cards(Trello::Constants::CURRENT_SPRINT_BOARD_ID) }
    
      it { should == [{}] }

      context "url" do
        after { subject }
     
        it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{Trello::Constants::CURRENT_SPRINT_BOARD_ID}/cards?key=#{Trello::Constants::USER_KEY}&token=#{Trello::Constants::READONLY_TOKEN}").and_return(uri) }
      end
    end
    
    context "request_lists" do
      subject { TrelloAdapter.request_lists(Trello::Constants::CURRENT_SPRINT_BOARD_ID) }
      it { should == [{}] }

      context "url" do
        after{ subject }

        it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{Trello::Constants::CURRENT_SPRINT_BOARD_ID}/lists?key=#{Trello::Constants::USER_KEY}&token=#{Trello::Constants::READONLY_TOKEN}").and_return(uri) }
      end
    end
  end
end