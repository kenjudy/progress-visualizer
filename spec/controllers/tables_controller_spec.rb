require 'spec_helper'
require 'json'

describe TablesController do
  include Trello::JsonData


  context "done_stories" do
   # let(:user) { FactoryGirl.create(:user, name: "name", password_hash: Password.create("pass")) }
    let(:adapter) { Adapters::TrelloAdapter }
    let(:list_id) { adapter.current_sprint_board_properties[:done_lists].keys.first }
    let(:label) { adapter.current_sprint_board_properties[:labels_types_of_work].first }
    let(:board) { Trello::Board.new(
                                    cards: [example_card_data("idList" => list_id, "labels" => [{name: label}])], 
                                    lists: [example_list_data("id" => list_id)]) 
                }

    before { adapter.stub(request_board: board) }
    
    subject { get :done_stories }
    context "requries authentication" do
      its(:code) { should == "401" }
    end
    
    context "assigns" do
      before do
        Rails.cache.delete("Tables::DoneStoriesTable.current")
        controller.fetch_current_results
      end
      it { assigns(:results).should == { lists: {label => {cards: board.cards, estimates: 2.5, stories: 1}}, totals: {total_stories: 1, total_estimates: 2.5}} }
    end
  end
end