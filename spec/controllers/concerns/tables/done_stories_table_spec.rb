require 'spec_helper'

describe "Tables::DoneStoriesTable" do
  include ProgressVisualizerTrello::JsonData
  include IterationConcern
  
  let(:user_profile) { FactoryGirl.create(:user_profile) }
  let(:done_stories_table) { Tables::DoneStoriesTable.new(user_profile) }
  
  let(:cards) do 
    (0..1).map do |i|
      example_card_data({ "idShort" => "#{i}", "idList" => "5170058469d58225070003ce", "labels" => [{color: "blue", name: "Committed"}], "name" => "(3) Foo #{i}" })
    end
  end
  
  let(:board) { ProgressVisualizerTrello::Board.new({lists: [example_list_data], cards: cards}) }
  let(:types_of_work) { ["Committed"] }
  let(:done_list_ids) { ["5170058469d58225070003ce"] }

  context "collate" do
    
    subject { done_stories_table.collate(board, types_of_work, done_list_ids) }
    
    its([:lists]) { should == {"Committed" => {cards: board.cards, :stories=>2, :estimates=>6.0} } }
    its([:totals]) { should == {:total_stories=>2, :total_estimates=>6.0}}
    its([:week_of]) { should == beginning_of_current_iteration.strftime("%B %l, %Y") }

    context "no types of work" do
      let(:types_of_work) { [] }
      its([:lists]) { should == {"" => {cards: board.cards, :stories=>2, :estimates=>6.0} } }
      its([:totals]) { should == {:total_stories=>2, :total_estimates=>6.0}}
    end
  end
  
  context "update_done_stories_for" do
    let(:collated_data) { done_stories_table.collate(board, types_of_work, done_list_ids) }
    before { done_stories_table.update_done_stories_for(collated_data) }
    subject { DoneStory.all }
    its(:count) { should == 2}
  end
  
  # context "no types of work" do
  #   let(:types_of_work) { [] }
  #   its(:count) { should == 2}
  # end
end
