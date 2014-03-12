require 'spec_helper'

describe "Factories::DoneStoryFactory" do
  include ProgressVisualizerTrello::JsonData
  include IterationConcern
  
  let(:board) { ProgressVisualizerTrello::Board.new({lists: [example_list_data], cards: cards}) }
  let(:types_of_work) { ["Committed"] }
  let(:done_list_ids) { ["5170058469d58225070003ce"] }
  let(:user_profile) { FactoryGirl.create(:user_profile, labels_types_of_work: types_of_work.join(",")) }
  let(:done_story_factory) { Factories::DoneStoryFactory.new(user_profile) }
  
  let(:cards) do 
    (0..1).map do |i|
      example_card_data({ "idShort" => "#{i}", "idList" => "5170058469d58225070003ce", "labels" => [{color: "blue", name: "Committed"}], "name" => "(3) Foo #{i}" })
    end
  end
  
  
  context "update_done_stories_for" do
    let(:collated_data) { done_story_factory.collate(board, types_of_work, done_list_ids, "2014-03-04") }
    before { done_story_factory.update_done_stories_for(collated_data) }
    subject { DoneStory.all }
    its(:count) { should == 2}
  end
  
  
  context "for_iteration" do
    before do
      ["Committed", "Inserted", "Contingent"].each do |type_of_work|
        (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: type_of_work, estimate: 2, timestamp: "2014-03-04", status: JSON.parse(user_profile.done_lists).keys.first) } 
        (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: type_of_work, estimate: 2, timestamp: "2014-03-04", status: "NOT DONE") } 
      end
    end 
    
    subject { done_story_factory.for_iteration("2014-03-04") }
    
    its([:totals]) { should == {:total_stories=>4, :total_estimates=>8.0} }
    its([:lists]) { should have(1).item }
  end
end
