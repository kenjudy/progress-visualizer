require 'spec_helper'

describe TrelloReport::Constants do
  
  context "private trello api constants" do
    it { expect(TrelloReport::Constants::USER_KEY).to_not be_nil }
    it { expect(TrelloReport::Constants::READONLY_TOKEN).to_not be_nil }
    it { expect(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID).to_not be_nil }
  end
  
  context "public trello api constants" do
    it { expect(TrelloReport::Constants::TRELLO_API_ROOT_URL).to eql("https://api.trello.com/1")}
    it { expect(TrelloReport::Constants::TRELLO_EXPORT_CARDS_PATH).to eql("/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>") }
  end

end