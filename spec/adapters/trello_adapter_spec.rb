require 'spec_helper'

require 'csv'

describe TrelloAdapter do
  include ActionView::Helpers::UrlHelper

  let(:trello_uri) { "https://trello.com/1"}
  let(:trello_api_uri) { "https://api.trello.com/1"}
  let(:user_profile) { FactoryGirl.create(:user_profile) }

  let(:adapter) { TrelloAdapter.new(user_profile) }

  before do
    allow(CSV).to receive_messages(open: [])
  end

  context "webhooks" do
    context "add" do

      subject do
        VCR.use_cassette('adapters/trello_adapter/add_webhook') do
          adapter.add_webhook(Rails.application.routes.url_helpers.webhooks_burn_up_url(host: "www.progress-visualizer.com", profile_id: user_profile.id, format: :json), "5170058469d58225070003cb")
        end
      end

      its(["id"]) { should_not be_nil }
      its(["description"]) { should == "#{user_profile.user.name} #{user_profile.name} burnup"}
      context "url" do
        let(:url) { "#{trello_uri}/tokens/#{user_profile.readonly_token}/webhooks/?key=#{Rails.application.config.trello[:app_key]}" }
        let(:uri) { URI.parse(url) }
        after { subject }

        it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
      end
    end
    context "delete" do
      let(:webhook_id) { "530d69f4ba42e3540e276228" }
      subject do
        VCR.use_cassette('adapters/trello_adapter/destroy_webhook') do
          adapter.destroy_webhook(webhook_id)
        end
      end

      its(:code) { should == "200" }
      its(:message) { should == "OK" }

      context "url" do
        let(:url) { "#{trello_uri}/webhooks/530d69f4ba42e3540e276228?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
        let(:uri) { URI.parse(url) }
        after { subject }

        it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
      end
    end
  end

  context "Cards" do
    context "request_all_cards_data" do
      subject do
        VCR.use_cassette('adapters/trello_adapter/request_all_cards_data') do
          adapter.request_all_cards_data(user_profile.current_sprint_board_id)
        end
      end

      it { is_expected.to have(35).items }

      context "url" do
        let(:url) { "#{trello_api_uri}/boards/#{user_profile.current_sprint_board_id}/cards/all?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
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

      it { is_expected.to have(34).items }

      context "url" do
        let(:url) { "#{trello_api_uri}/boards/#{user_profile.current_sprint_board_id}/cards?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
        let(:uri) { URI.parse(url) }
        after { subject }

        it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
      end
    end
    
    context "card api" do
      let(:card_id) do
        VCR.use_cassette('adapters/trello_adapter/request_cards_data') do
          adapter.request_cards_data(user_profile.current_sprint_board_id).first["id"]
        end
      end

      context "request_card" do
        subject do
          VCR.use_cassette('adapters/trello_adapter/request_card') do
            adapter.request_card_data(card_id)
          end
        end

        it { is_expected.to have_at_least(1).items }

        context "url" do
          let(:url) { "#{trello_api_uri}/cards/#{card_id}?board_fields=all&key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
          let(:uri) { URI.parse(url) }
          after { subject }
      
          it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
        end
      end
    
      context "request_card_activity" do
        subject do
          VCR.use_cassette('adapters/trello_adapter/request_card_activity') do
            adapter.request_card_activity_data(card_id)
          end
        end

        it { is_expected.to have_at_least(1).items }

        context "url" do
          let(:url) { "#{trello_api_uri}/cards/#{card_id}/actions?filter=all&key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
          let(:uri) { URI.parse(url) }
          after { subject }
      
          it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
        end
      end
    end
  end

  context "request_lists_data" do
    subject do
      VCR.use_cassette('adapters/trello_adapter/request_lists_data') do
        adapter.request_lists_data(user_profile.current_sprint_board_id)
      end
    end

    it { is_expected.to have(4).items }

    context "url" do
      let(:url) { "#{trello_api_uri}/boards/#{user_profile.current_sprint_board_id}/lists?key=#{Rails.application.config.trello[:app_key]}&token=#{user_profile.readonly_token}" }
      let(:uri) { URI.parse(url) }
      after{ subject }

      it { expect(adapter).to receive(:parse_url_string).with(url).and_return(uri) }
    end
  end

  context "user_token_url" do
    subject { adapter.user_token_url }

    it { is_expected.to eq("#{trello_uri}/authorize?key=#{Rails.application.config.trello[:app_key]}&name=ProgressVisualizer&expiration=never&response_type=token")}
  end
end