require 'spec_helper'

require 'csv'

module Adapters
  describe TrelloAdapter do
    include Trello::JsonData
    
    let(:uri) { double(URI, read: "[{}]" ) }

    let(:card_json) { example_card_json_string }
    let(:card_data) { JSON.parse(card_json) }
    let(:card) { Trello::Card.new(card_data) }

    let(:list_json) { example_list_json_string }
    let(:list_data) { JSON.parse(list_json) }
    let(:list) { Trello::List.new(list_data) }
    
    let(:board) { Trello::Board.new(lists: [list_data], cards: [card_data]) }
 
    before do
      URI.stub(parse: uri)
      CSV.stub(open: [])
    end
    
    context "request_board" do
      
      before do
        TrelloAdapter.stub(request_cards_data: [card_data])
        TrelloAdapter.stub(request_archived_cards_data: [card_data])
        TrelloAdapter.stub(request_lists_data: [list_data])
      end
      
      subject { TrelloAdapter.request_board(Trello::Constants::CURRENT_SPRINT_BOARD[:id]) }
    
      its(:lists) { should have(1).item}
      its(:cards) { should have(1).item}
      
      context "request_board with archived cards" do
        subject { TrelloAdapter.request_board(Trello::Constants::CURRENT_SPRINT_BOARD[:id], true) }
        its(:cards) { should have(2).items}
      end
    end

    context "request cards data" do
      before { uri.stub(read: "[#{card_json}]")}

      context "archived" do
        subject { TrelloAdapter.request_archived_cards_data(Trello::Constants::CURRENT_SPRINT_BOARD[:id]) }
    
        it { should have(1).item }

        context "url" do
          after { subject }
     
          it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{Trello::Constants::CURRENT_SPRINT_BOARD[:id]}/cards/closed?key=#{Trello::Constants::USER_KEY}&token=#{Trello::Constants::READONLY_TOKEN}").and_return(uri) }
        end
      end
    
      context "current" do
        subject { TrelloAdapter.request_cards_data(Trello::Constants::CURRENT_SPRINT_BOARD[:id]) }
    
        it { should have(1).item }

        context "url" do
          after { subject }
     
          it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{Trello::Constants::CURRENT_SPRINT_BOARD[:id]}/cards?key=#{Trello::Constants::USER_KEY}&token=#{Trello::Constants::READONLY_TOKEN}").and_return(uri) }
        end
      end
    end
    
    context "request_lists_data" do
      before { uri.stub(read: "[#{list_json}]")}

      subject { TrelloAdapter.request_lists_data(Trello::Constants::CURRENT_SPRINT_BOARD[:id]) }
      it { should have(1).item }

      context "url" do
        after{ subject }

        it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{Trello::Constants::CURRENT_SPRINT_BOARD[:id]}/lists?key=#{Trello::Constants::USER_KEY}&token=#{Trello::Constants::READONLY_TOKEN}").and_return(uri) }
      end
    end
  end
end