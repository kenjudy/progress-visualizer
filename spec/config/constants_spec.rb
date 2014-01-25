require 'spec_helper'

describe Trello::Constants do
  
  context "private trello api constants" do
    it { expect(Trello::Constants::USER_KEY).to_not be_nil }
    it { expect(Trello::Constants::READONLY_TOKEN).to_not be_nil }
    it { expect(Trello::Constants::CURRENT_SPRINT_BOARD_ID).to_not be_nil }
    it { expect(Trello::Constants::CURRENT_SPRINT_BOARD_DONE_LIST_IDS).to have_at_least(1).item }
    it { expect(Trello::Constants::CURRENT_SPRINT_BOARD_BACKLOG_LIST_IDS).to have_at_least(Trello::Constants::CURRENT_SPRINT_BOARD_DONE_LIST_IDS.length).items }
  end
  
  context "public trello api constants" do
    it { expect(Trello::Constants::TRELLO_API_ROOT_URL).to eql("https://api.trello.com/1")}
    it { expect(Trello::Constants::TRELLO_EXPORT_CARDS_PATH).to eql("/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>") }
    it { expect(Trello::Constants::TRELLO_EXPORT_ARCHIVED_CARDS_PATH).to eql("/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>") }
    it { expect(Trello::Constants::TRELLO_BOARD_LISTS_PATH).to eql("/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>") }
  end

end