require 'spec_helper'
require 'json'

describe TablesController do
  include Trello::JsonData


  context "done_stories" do
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
    
  end
end