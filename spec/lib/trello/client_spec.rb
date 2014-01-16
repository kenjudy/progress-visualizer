require 'spec_helper'
require_relative '../../models/trello/json_data'

module Trello
  describe Client do
    include JsonData
    
    let(:uri) { double(URI, read: "[{}]" ) }
    before { URI.stub(parse: uri) }

    context "request json" do
      subject { Client.request_archived_cards(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID) }
    
      it { should == [{}] }
    
    end
    
    context "form request URL" do
      it { expect(Client.archived_cards_url(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID)).to eql("https://api.trello.com/1/boards/#{TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID}/cards/closed?key=#{TrelloReport::Constants::USER_KEY}&token=#{TrelloReport::Constants::READONLY_TOKEN}")}
    end


  end
end