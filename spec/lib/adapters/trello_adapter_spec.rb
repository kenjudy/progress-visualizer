require 'spec_helper'

require 'csv'

module Adapters
  describe TrelloAdapter do
    include ProgressVisualizerTrello::JsonData
    
    let(:uri) { double(URI, read: "[{}]" ) }

    let(:card_json) { example_card_json_string }
    let(:card_data) { JSON.parse(card_json) }
    let(:card) { ProgressVisualizerTrello::Card.new(card_data) }

    let(:list_json) { example_list_json_string }
    let(:list_data) { JSON.parse(list_json) }
    let(:list) { ProgressVisualizerTrello::List.new(list_data) }
    
    let(:user_profile) { FactoryGirl.create(:user_profile) }
    
    let(:board) { ProgressVisualizerTrello::Board.new(lists: [list_data], cards: [card_data]) }
    let(:adapter) { TrelloAdapter.new(user_profile) }
 
    before do
      URI.stub(parse: uri)
      CSV.stub(open: [])
    end
    
    context "webhooks" do
      context "add" do
        
      end
      context "delete" do
        
      end
    end
    
    context "request_board" do
      
      before do
        adapter.stub(request_cards_data: [card_data])
        adapter.stub(request_archived_cards_data: [card_data])
        adapter.stub(request_lists_data: [list_data])
      end
      
      subject { adapter.request_board(user_profile.current_sprint_board_id) }
    
      its(:lists) { should have(1).item}
      its(:cards) { should have(1).item}
      
      context "request_board with archived cards" do
        subject { adapter.request_board(user_profile.current_sprint_board_id, true) }
        its(:cards) { should have(2).items}
      end
    end

    context "request cards data" do
      before { uri.stub(read: "[#{card_json}]")}

      context "archived" do
        subject { adapter.request_archived_cards_data(user_profile.current_sprint_board_id) }
    
        it { should have(1).item }

        context "url" do
          after { subject }
     
          it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{user_profile.current_sprint_board_id}/cards/closed?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}").and_return(uri) }
        end
      end
    
      context "current" do
        subject { adapter.request_cards_data(user_profile.current_sprint_board_id) }
    
        it { should have(1).item }

        context "url" do
          after { subject }
     
          it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{user_profile.current_sprint_board_id}/cards?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}").and_return(uri) }
        end
      end
    end
    
    context "request_lists_data" do
      before { uri.stub(read: "[#{list_json}]")}

      subject { adapter.request_lists_data(user_profile.current_sprint_board_id) }
      it { should have(1).item }

      context "url" do
        after{ subject }

        it { expect(URI).to receive(:parse).with("https://api.trello.com/1/boards/#{user_profile.current_sprint_board_id}/lists?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}").and_return(uri) }
      end
    end
        
    context "request_user_token_url" do
      subject { adapter.request_user_token_url }
      
      it { should == "https://trello.com/1/authorize?key=#{Rails.application.config.trello[:app_key]}&name=ProgressVisualizer&expiration=never&response_type=token"}
    end
  end
end