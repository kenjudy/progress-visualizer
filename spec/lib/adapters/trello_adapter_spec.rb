require 'spec_helper'
require_relative '../../models/trello/json_data'

module Adapters
  describe TrelloAdapter do
    include JsonData
    
    let(:uri) { double(URI, read: "[{}]" ) }
    before do
      URI.stub(parse: uri)
      CSV.stub(open: [])
    end
    
    context "daily burnup" do
      let(:json) { JSON.parse(card_json_string) }
      let(:card) { Trello::Card.new(json) }
      subject do
        board = TrelloAdapter.daily_burnup
        board.cards.first
      end
      
      before { TrelloAdapter.stub(request_cards: [json])}
      
      its(:id) { should == card.id }
      
      context "requests cards" do
        after { TrelloAdapter.daily_burnup }
        it { expect(TrelloAdapter).to receive(:request_cards).with(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID)}
      end
    end

    context "request_archived_cards" do
      subject { TrelloAdapter.request_archived_cards(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID) }
    
      it { should == [{}] }

      context "url" do
        after { subject }
     
        it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID}/cards/closed?key=#{TrelloReport::Constants::USER_KEY}&token=#{TrelloReport::Constants::READONLY_TOKEN}").and_return(uri) }
      end
    end
    context "request_cards" do
      subject { TrelloAdapter.request_cards(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID) }
    
      it { should == [{}] }

      context "url" do
        after { subject }
     
        it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID}/cards?key=#{TrelloReport::Constants::USER_KEY}&token=#{TrelloReport::Constants::READONLY_TOKEN}").and_return(uri) }
      end
    end
  end
end