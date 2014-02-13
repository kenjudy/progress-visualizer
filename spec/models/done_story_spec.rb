require 'spec_helper'

describe DoneStory do
  include ProgressVisualizerTrello::JsonData

  context "done_stories_data" do
    let(:iteration_start) { Rails.application.config.iteration_start }
    before do
      [0,1.week,2.weeks].each do |weeks|
        (0..3).each { FactoryGirl.create(:done_story, type_of_work: "Committed", timestamp: Rails.application.config.iteration_start - weeks + 1.day) } 
        (0..3).each { FactoryGirl.create(:done_story, type_of_work: "Contingent", timestamp: Rails.application.config.iteration_start - weeks + 1.day) } 
        (0..3).each { FactoryGirl.create(:done_story, type_of_work: "Inserted", timestamp: Rails.application.config.iteration_start - weeks + 1.day) } 
      end
    end 
    
    let(:include_current) { false }
    subject { DoneStory.done_stories_data(3, include_current) }
    
    its(:length) { should == 24 }
    its(:first) { should be_instance_of(DoneStory) }
    it("doesn't contain this iteration") { expect(subject.last.timestamp < iteration_start) }

    context "include current" do
      let(:include_current) { true }
      its(:length) { should == 36 }
      it("contains this iteration") { expect(subject.last.timestamp >= iteration_start) }
    end

  end
  
  context "create_or_update_from" do
    let(:card) { ProgressVisualizerTrello::Card.new(example_card_data({ "idList" => "5170058469d58225070003ce", "labels" => [{color: "blue", name: "Committed"}], "name" => "(3) Test Story Name" })) }
    let(:type_of_work) { "Committed" }
    
    context "creates story from card" do
      before { DoneStory.create_or_update_from(card, type_of_work, Time.now) }
      subject { DoneStory.last }
      its(:story) { should == "Test Story Name"}
    end
    
    context "does not create dups by idShort" do
      let(:cards) { (0..3).map { ProgressVisualizerTrello::Card.new(example_card_data({ "idShort" => "3" })) } }
      before { cards.each { |card| DoneStory.create_or_update_from(card, type_of_work, Time.now) } }

      subject { DoneStory.all }
      its(:length) { should == 1 }
    end
  end
  
end