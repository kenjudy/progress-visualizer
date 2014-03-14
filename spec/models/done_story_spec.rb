require 'spec_helper'

describe DoneStory do
  include ProgressVisualizerTrello::JsonData

  let(:user_profile) { FactoryGirl.create(:user_profile) }

  context "create_or_update_from" do
    let(:card) { ProgressVisualizerTrello::Card.new(example_card_data({ "idList" => "5170058469d58225070003ce", "labels" => [{color: "blue", name: "Committed"}], "name" => "(3) Test Story Name" })) }
    let(:type_of_work) { "Committed" }

    context "creates story from card" do
      before { DoneStory.create_or_update_from(user_profile, card, type_of_work, Time.now) }
      subject { DoneStory.last }
      its(:story) { should == "Test Story Name"}
      its(:type_of_work) { should == "Committed"}

      context "no type of work in user profile" do
        let(:type_of_work) { nil }
        its(:type_of_work) { should be_nil }
      end
    end

    context "does not create dups by idShort" do
      let(:cards) { (0..3).map { ProgressVisualizerTrello::Card.new(example_card_data({ "idShort" => "3" })) } }
      before { cards.each { |card| DoneStory.create_or_update_from(user_profile, card, type_of_work, Time.now) } }

      subject { DoneStory.all }
      its(:length) { should == 1 }
    end
  end
  
  context "iteration" do
    let(:today) { Date.today }
    let(:iterations) { (0..3).map { |offset| (today - (offset * user_profile.duration).days).strftime("%Y-%m-%d") } }
    before { iterations.each { |iteration| FactoryGirl.create(:done_story, user_profile: user_profile, iteration: iteration) } }
    
    context "prior" do
      let(:done_story) { DoneStory.find_by(iteration: iterations[2])}
      subject { done_story.prior_iteration }
      it { should == iterations[3] }
      context "earliest iteration" do
        let(:done_story) { DoneStory.find_by(iteration: iterations[3])}
        it { should be_nil }
      end
    end
    context "next" do
      let(:done_story) { DoneStory.find_by(iteration: iterations[2])}
      subject { done_story.next_iteration }
      it { should == iterations[1] }
      context "most recent iteration" do
        let(:done_story) { DoneStory.find_by(iteration: iterations[0])}
        it { should be_nil }
      end
    end
  end

end