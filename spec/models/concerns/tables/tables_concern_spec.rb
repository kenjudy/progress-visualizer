require 'spec_helper'

class TestObject
  include Tables::TablesConcern
  include IterationConcern
  include UserProfileConcern

end

describe Tables::TablesConcern do
  include ProgressVisualizerTrello::JsonData


  let(:user_profile) { FactoryGirl.create(:user_profile) }
  let(:test_object) { TestObject.new(user_profile) }

  let(:cards) do
    (0..1).map do |i|
      example_card_data({ "idShort" => "#{i}", "idList" => "5170058469d58225070003ce", "labels" => [{color: "blue", name: "Committed"}], "name" => "(3) Foo #{i}" })
    end
  end

  let(:board) { ProgressVisualizerTrello::Board.new({lists: [example_list_data], cards: cards}) }
  let(:types_of_work) { ["Committed"] }
  let(:done_list_ids) { ["5170058469d58225070003ce"] }

  context "collate" do

    subject { test_object.collate(board, types_of_work, done_list_ids) }

    its([:lists]) { should == {"Committed" => {cards: board.cards, :stories=>2, :estimates=>6.0} } }
    its([:totals]) { should == {:total_stories=>2, :total_estimates=>6.0}}

    context "no types of work" do
      let(:types_of_work) { [] }
      its([:lists]) { should == {"" => {cards: board.cards, :stories=>2, :estimates=>6.0} } }
      its([:totals]) { should == {:total_stories=>2, :total_estimates=>6.0}}
      its([:iteration_range]) { should == "#{test_object.beginning_of_current_iteration.strftime("%B %e, %Y")} - #{test_object.end_of_current_iteration.strftime("%B %e, %Y")}" }
    end
  end

  context "cache_key" do
    subject { test_object.cache_key }
    it { should == "#{Rails.env}::TestObject.current:user#{user_profile.user.id}:profile#{user_profile.id})" }
  end
end