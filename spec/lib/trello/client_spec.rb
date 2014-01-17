require 'spec_helper'
require_relative '../../models/trello/json_data'

module Trello
  describe Client do
    include JsonData
    
    let(:uri) { double(URI, read: "[{}]" ) }
    before { URI.stub(parse: uri) }
    
    context "daily burnup" do
      let(:json) { JSON.parse(card_json_string) }
      let(:card) { Card.new(json) }
      subject do
        cards = Client.daily_burnup
        cards.first
      end
      
      before { Client.stub(request_cards: [json])}
      
      its(:id) { should == card.id }
      
      context "requests cards" do
        after { Client.daily_burnup }
        it { expect(Client).to receive(:request_cards).with(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID)}
      end
    end

    context "request_archived_cards" do
      subject { Client.request_archived_cards(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID) }
    
      it { should == [{}] }

      context "url" do
        after { subject }
     
        it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID}/cards/closed?key=#{TrelloReport::Constants::USER_KEY}&token=#{TrelloReport::Constants::READONLY_TOKEN}").and_return(uri) }
      end
    end
    context "request_cards" do
      subject { Client.request_cards(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID) }
    
      it { should == [{}] }

      context "url" do
        after { subject }
     
        it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID}/cards?key=#{TrelloReport::Constants::USER_KEY}&token=#{TrelloReport::Constants::READONLY_TOKEN}").and_return(uri) }
      end
    end
  end
end