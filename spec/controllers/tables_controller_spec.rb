require 'spec_helper'
require 'json'

describe TablesController do
  include Trello::JsonData

  @@adapter = Adapters::TrelloAdapter

  context "overview" do
    let(:list_id) { @@adapter.current_sprint_board_properties[:done_list_ids].first }
    let(:label) { @@adapter.current_sprint_board_properties[:labels_types_of_work].first }
    let(:board) { Trello::Board.new(
      cards: [example_card_data("idList" => list_id, "labels" => [{name: label}])], 
      lists: [example_list_data("id" => list_id)]) }

    before { @@adapter.stub(request_board: board) }
    
    subject { get :overview }
    
    its(:code) { "200" }
    
    context "assigns" do
      before { subject }
      it { assigns(:results).should == { lists: {label => {cards: board.cards, estimates: 2.5, stories: 1}}, totals: {total_stories: 1, total_estimates: 2.5}} }
    end
  end
end