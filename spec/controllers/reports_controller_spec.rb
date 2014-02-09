require 'spec_helper'

describe ReportsController do
  include ProgressVisualizerTrello::JsonData

  let(:adapter) { Adapters::TrelloAdapter }
  let(:list_id) { adapter.current_sprint_board_properties[:done_lists].keys.first }
  let(:label) { adapter.current_sprint_board_properties[:labels_types_of_work].first }
  let(:board) { ProgressVisualizerTrello::Board.new(
                                  cards: [example_card_data("idList" => list_id, "labels" => [{name: label}])], 
                                  lists: [example_list_data("id" => list_id)]) 
              }

  before { adapter.stub(request_board: board) }

  context "not authenticated" do
    subject { get :performance_summary }

    its(:code) { should == "302" }

  end

  context "authenticated" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    subject { get :performance_summary }
  
    its(:code) { should == "200" }

  end
  
end