require 'spec_helper'

describe Constants do
  
  context "private trello api constants" do
    it { expect(Rails.application.config.trello[:app_key]).to_not be_nil }
    it { expect(Rails.application.config.trello[:readonly_token]).to_not be_nil }
    
    context "current sprint board" do
      subject { Rails.application.config.current_sprint_board }
      
      its([:id]) { should_not be_nil }
      its([:backlog_lists]) { should have_at_least(1).item }
      its([:done_lists]) { should have_at_least(Rails.application.config.current_sprint_board[:done_lists].keys.length).items }
      its([:labels_types_of_work]) { should have_at_least(Rails.application.config.current_sprint_board[:labels_types_of_work].length).items }
    end
  end
  
  context "public trello api constants" do
    it { expect(Rails.application.config.trello[:api_root_url]).to eql("https://api.trello.com/1")}
    it { expect(Rails.application.config.trello[:export_cards_path]).to eql("/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>") }
    it { expect(Rails.application.config.trello[:export_archived_cards_path]).to eql("/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>") }
    it { expect(Rails.application.config.trello[:board_lists_path]).to eql("/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>") }
  end
  
  context "iteration constants" do
    it { expect(Rails.application.config.iteration_start).to eql (Time.zone.local_to_utc(Date.today.end_of_week.to_datetime - 6.days + 11.hours))}
    it { expect(Rails.application.config.iteration_end).to eql (Time.zone.local_to_utc(Date.today.end_of_week.to_datetime + 1)) }
  end
  
  context "email" do
    it { expect(Rails.application.config.email_default_from).to_not be_nil }
  end
  
end