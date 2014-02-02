require 'spec_helper'

describe DoneStory do
  context "done_stories_data" do
    before do
      [0,1.week,2.weeks].each do |weeks|
        (0..3).each { FactoryGirl.create(:done_story, type_of_work: "Committed", timestamp: Date.today - weeks) } 
        (0..3).each { FactoryGirl.create(:done_story, type_of_work: "Contingent", timestamp: Date.today - weeks) } 
        (0..3).each { FactoryGirl.create(:done_story, type_of_work: "Inserted", timestamp: Date.today - weeks) } 
      end
    end 
    
    let(:include_current) { false }
    subject { DoneStory.done_stories_data(1, include_current) }
    
    its(:length) { should == 12 }
    its(:first) { should be_instance_of(DoneStory) }
    it("doesn't contain this week") { expect(subject.last.timestamp == Date.today - 1.week) }

    context "include current" do
      let(:include_current) { true }
      it("contains this week") { expect(subject.last.timestamp == Date.today) }
    end

  end
end