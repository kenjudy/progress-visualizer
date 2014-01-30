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
    
    subject { DoneStory.done_stories_data(1)}
    
    its(:length) { should == 24 }
    its(:first) { should be_instance_of(DoneStory)}

  end
  
  
end