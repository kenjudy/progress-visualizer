require 'spec_helper'

describe "Tables::DoneStoriesTable" do
  include ProgressVisualizerTrello::JsonData
  
  let(:cards) do 
    (0..1).map do |i|
      example_card_data({ "idShort" => "#{i}", "idList" => "5170058469d58225070003ce", "labels" => [{color: "blue", name: "Committed"}], "name" => "(3) Foo #{i}" })
    end
  end
  
  let(:board) { ProgressVisualizerTrello::Board.new({lists: [example_list_data], cards: cards}) }
  let(:types_of_work) { ["Committed"] }
  let(:done_list_ids) { ["5170058469d58225070003ce"] }

  context "collate" do
    
    subject { Tables::DoneStoriesTable.collate(board, types_of_work, done_list_ids) }
    
    its([:lists]) { should == {"Committed" => {cards: board.cards, :stories=>2, :estimates=>6.0} } }
    its([:totals]) { should == {:total_stories=>2, :total_estimates=>6.0}}
    its([:week_of]) { should == "February  4, 2014" }
  end
  
  context "update_done_stories_for" do
    let(:collated_data) { Tables::DoneStoriesTable.collate(board, types_of_work, done_list_ids) }
    before { Tables::DoneStoriesTable.update_done_stories_for(collated_data) }
    subject { DoneStory.all }
    its(:count) { should == 2}
  end
end
