require_relative '../app/constants'

include TrelloReport::Constants

describe TrelloReport::Constants do

  context "private trello api constants" do
    it { expect(@@user_key).to_not be_nil }
    it { expect(@@readonly_token).to_not be_nil }
    it { expect(@@current_sprint_board_id).to_not be_nil }
  end
  
  context "public trello api constants" do
    it { expect(@@trello_api_root_url).to eql("https://api.trello.com/1")}
    it { expect(@@trello_export_cards_path).to eql("/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>") }
  end

end