require 'spec_helper'

describe Constants do
  
  context "private trello api constants" do
    it { expect(Constants::TRELLO[:app_key]).to_not be_nil }
    it { expect(Constants::TRELLO[:readonly_token]).to_not be_nil }
    
    context "current sprint board" do
      subject { Constants::CONFIG[:current_sprint_board] }
      
      its([:id]) { should_not be_nil }
      its([:backlog_lists]) { should have_at_least(1).item }
      its([:done_lists]) { should have_at_least(Constants::CONFIG[:current_sprint_board][:done_lists].keys.length).items }
      its([:labels_types_of_work]) { should have_at_least(Constants::CONFIG[:current_sprint_board][:labels_types_of_work].length).items }
    end
  end
  
  context "public trello api constants" do
    it { expect(Constants::TRELLO[:api_root_url]).to eql("https://api.trello.com/1")}
    it { expect(Constants::TRELLO[:export_cards_path]).to eql("/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>") }
    it { expect(Constants::TRELLO[:export_archived_cards_path]).to eql("/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>") }
    it { expect(Constants::TRELLO[:board_lists_path]).to eql("/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>") }
  end
  
  context "iteration constants" do
    it { expect(Constants::CONFIG[:iteration_start]).to eql (Date.today.end_of_week.to_datetime - 6.days + 12.hours)}
    it { expect(Constants::CONFIG[:iteration_end]).to eql (Date.today.end_of_week.to_datetime + 1) }
  end
  
  context "email" do
    it { expect(Constants::CONFIG[:email_default_from]).to_not be_nil }
  end
  
end