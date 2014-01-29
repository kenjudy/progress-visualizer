require 'spec_helper'

describe Constants do
  
  context "private trello api constants" do
    it { expect(Constants::TRELLO[:user_key]).to_not be_nil }
    it { expect(Constants::TRELLO[:readonly_token]).to_not be_nil }
    
    context "current sprint board" do
      subject { Constants::CURRENT_SPRINT_BOARD }
      
      its([:id]) { should_not be_nil }
      its([:backlog_list_ids]) { should have_at_least(1).item }
      its([:done_list_ids]) { should have_at_least(Constants::CURRENT_SPRINT_BOARD[:done_list_ids].length).items }
      its([:labels_types_of_work]) { should have_at_least(Constants::CURRENT_SPRINT_BOARD[:labels_types_of_work].length).items }
    end
  end
  
  context "public trello api constants" do
    it { expect(Constants::TRELLO[:api_root_url]).to eql("https://api.trello.com/1")}
    it { expect(Constants::TRELLO[:export_cards_path]).to eql("/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>") }
    it { expect(Constants::TRELLO[:export_archived_cards_path]).to eql("/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>") }
    it { expect(Constants::TRELLO[:board_lists_path]).to eql("/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>") }
  end
  
  context "iteration constants" do
    before do
      Constants::ITERATION_CONFIG['duration'] = "WEESLY"
      Constants::ITERATION_CONFIG['start_day_of_week'] = 1
    end
    it { expect(Constants::ITERATION[:iteration_start]).to eql (Date.today.end_of_week - 6.days)}
    it { expect(Constants::ITERATION[:iteration_end]).to eql (Date.today.end_of_week) }
  end
  
end