require 'spec_helper'

require 'csv'

module Adapters
  describe TrelloAdapter do
    include ActionView::Helpers::UrlHelper
    
    
    let(:user_profile) { FactoryGirl.create(:user_profile) }
    
    let(:adapter) { TrelloAdapter.new(user_profile) }
 
    before do
      CSV.stub(open: [])
    end
    
    context "webhooks" do
      context "add" do

        subject do
          VCR.use_cassette('adapters/trello_adapter/add_webhook') do
            adapter.add_webhook(Rails.application.routes.url_helpers.webhooks_burn_up_url(host: "www.progress-visualizer.com", profile_id: user_profile.id, format: :json), "5170058469d58225070003cb")
          end
        end
        
        its(:external_id) { should_not be_nil }
        its(:description) { should == "#{user_profile.user.name} #{user_profile.name} burnup"}
        its(:id_model) { should == "5170058469d58225070003cb"}
        its(:callback_url) { should =~ /ian4atzhmmh9ul\/burn-up\/\d+\.json/ }
        
        context "url" do
          let(:url) { "https://trello.com/1/tokens/#{user_profile.readonly_token}/webhooks/?key=#{Rails.application.config.trello[:app_key]}" }
          let(:uri) { URI.parse(url) }
          after { subject }
          
          it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
        end
      end
      context "delete" do
        let(:webhook) { Webhook.new(external_id: "530d69f4ba42e3540e276228")}
        subject do
          VCR.use_cassette('adapters/trello_adapter/destroy_webhook') do
            adapter.destroy_webhook(webhook)
          end
        end
        
        its(:code) { should == "200" }
        its(:message) { should == "OK" }
        
        context "url" do
          let(:url) { "https://trello.com/1/webhooks/530d69f4ba42e3540e276228?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
          let(:uri) { URI.parse(url) }
          after { subject }
          
          it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
        end
      end
    end
    
    context "request_board" do
            
      subject do
        VCR.use_cassette('adapters/trello_adapter/request_board') do
          adapter.request_board(user_profile.current_sprint_board_id)
        end
      end
    
      its(:lists) { should have(4).items}
      its(:cards) { should have(34).items}
      
      context "request_board with archived cards" do
        subject do
          VCR.use_cassette('adapters/trello_adapter/request_board_archived_cards') do
            adapter.request_board(user_profile.current_sprint_board_id, true)
          end
        end
        its(:cards) { should have(35).items}
      end
    end

    context "cards" do
      context "request_all_cards_data" do
        subject do
          VCR.use_cassette('adapters/trello_adapter/request_all_cards_data') do
            adapter.request_all_cards_data(user_profile.current_sprint_board_id)
          end
        end
    
        it { should have(35).items }

        context "url" do
          let(:url) { "https://api.trello.com/1/boards/#{user_profile.current_sprint_board_id}/cards/all?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
          let(:uri) { URI.parse(url) }
          after { subject }
     
          it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
        end
      end
    
      context "request_cards_data" do
        subject do
          VCR.use_cassette('adapters/trello_adapter/request_cards_data') do
            adapter.request_cards_data(user_profile.current_sprint_board_id)
          end
        end

        it { should have(34).items }

        context "url" do
          let(:url) { "https://api.trello.com/1/boards/#{user_profile.current_sprint_board_id}/cards?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
          let(:uri) { URI.parse(url) }
          after { subject }
     
          it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
        end
      end
    end
    
    context "request_lists_data" do
      subject do
        VCR.use_cassette('adapters/trello_adapter/request_lists_data') do
          adapter.request_lists_data(user_profile.current_sprint_board_id) 
        end
      end
       
      it { should have(4).items }

      context "url" do
        let(:url) { "https://api.trello.com/1/boards/#{user_profile.current_sprint_board_id}/lists?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
        let(:uri) { URI.parse(url) }
        after{ subject }

        it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
      end
    end
        
    context "user_token_url" do
      subject { adapter.user_token_url }
      
      it { should == "https://trello.com/1/authorize?key=#{Rails.application.config.trello[:app_key]}&name=ProgressVisualizer&expiration=never&response_type=token"}
    end
  end
end