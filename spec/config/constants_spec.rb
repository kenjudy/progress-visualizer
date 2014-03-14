require 'spec_helper'

describe Constants do

  context "private trello api constants" do
    it { expect(Rails.application.config.trello[:app_key]).to_not be_nil }

   end

  context "public trello api constants" do
    it { expect(Rails.application.config.trello[:api_root_url]).to eql("https://api.trello.com/1")}
    it { expect(Rails.application.config.trello[:export_cards_path]).to eql("/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>") }
    it { expect(Rails.application.config.trello[:export_all_cards_path]).to eql("/boards/<BOARD_ID>/cards/all?key=<KEY>&token=<TOKEN>") }
    it { expect(Rails.application.config.trello[:board_lists_path]).to eql("/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>") }
    it { expect(Rails.application.config.trello[:board_meta_path]).to eql("/boards/<BOARD_ID>?key=<KEY>&token=<TOKEN>") }
    it { expect(Rails.application.config.trello[:add_webhooks_path]).to eql("/tokens/<TOKEN>/webhooks/?key=<KEY>") }
  end

  context "email" do
    it { expect(Rails.application.config.email_default_from).to_not be_nil }
  end

end