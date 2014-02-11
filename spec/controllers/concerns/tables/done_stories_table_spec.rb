require 'spec_helper'

describe "Tables::DoneStoriesTable" do
  include ProgressVisualizerTrello::JsonData
  after { Rails.cache.delete("#{Rails.env}::Tables::DoneStoriesTable.current") }
  
  let(:cards) do 
    (0..1).map do
      example_card_data({ "idList" => "5170058469d58225070003ce", "labels" => [{color: "blue", name: "Committed"}], "name" => "(3) Foo" })
    end
  end
  
  let(:board) { ProgressVisualizerTrello::Board.new(lists: [example_list_data], cards: cards) }
  let(:adapter) { Adapters::TrelloAdapter }

  before { adapter.stub(request_board: board) }

  context "current" do
    subject { Tables::DoneStoriesTable.current_without_cache(adapter) }
    its([:totals]) { should == {:total_stories=>2, :total_estimates=>6} }
  end

  context "update" do
    let(:story) { FactoryGirl.build(:done_story) }
    before { DoneStory.stub(find_or_initialize_by: story)}
    after { Tables::DoneStoriesTable.update }
    
    it("should create done story") { expect(story).to receive(:update_attributes).at_least(:once).with({:type_of_work=>"Committed", :status=>"5170058469d58225070003ce", :story=>"Foo", :estimate=>3.0}) }
  end
end
