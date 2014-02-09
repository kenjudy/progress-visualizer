require 'spec_helper'
require 'json'

describe TablesController do
  include ProgressVisualizerTrello::JsonData


  context "done_stories" do
    let(:adapter) { Adapters::TrelloAdapter }
    let(:list_id) { adapter.current_sprint_board_properties[:done_lists].keys.first }
    let(:label) { adapter.current_sprint_board_properties[:labels_types_of_work].first }
    let(:board) { ProgressVisualizerTrello::Board.new(
                                    cards: [example_card_data("idList" => list_id, "labels" => [{name: label}])], 
                                    lists: [example_list_data("id" => list_id)]) 
                }

    before { adapter.stub(request_board: board) }
    
    context "not authenticated" do
      subject { get :done_stories }
  
      its(:code) { should == "302" }

    end
  
    context "authenticated" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      subject { get :done_stories }
    
      its(:code) { should == "200" }

    end
  end
end