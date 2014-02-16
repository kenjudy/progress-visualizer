require 'spec_helper'

describe DoneStory do
  include ProgressVisualizerTrello::JsonData
  
  context "create_or_update_from" do
    let(:user_profile) { FactoryGirl.create(:user_profile) }
    let(:card) { ProgressVisualizerTrello::Card.new(example_card_data({ "idList" => "5170058469d58225070003ce", "labels" => [{color: "blue", name: "Committed"}], "name" => "(3) Test Story Name" })) }
    let(:type_of_work) { "Committed" }
    
    context "creates story from card" do
      before { DoneStory.create_or_update_from(user_profile, card, type_of_work, Time.now) }
      subject { DoneStory.last }
      its(:story) { should == "Test Story Name"}
    end
    
    context "does not create dups by idShort" do
      let(:cards) { (0..3).map { ProgressVisualizerTrello::Card.new(example_card_data({ "idShort" => "3" })) } }
      before { cards.each { |card| DoneStory.create_or_update_from(user_profile, card, type_of_work, Time.now) } }

      subject { DoneStory.all }
      its(:length) { should == 1 }
    end
  end
  
end