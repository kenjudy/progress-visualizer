require 'spec_helper'

describe DoneStory do
  context "select_yesterdays_weather" do
    before do
      [0,6,12].each do |days|
        (0..3).each { FactoryGirl.create(:done_story, type_of_work: "Committed", timestamp: Date.today - days) } 
        (0..3).each { FactoryGirl.create(:done_story, type_of_work: "Contingent", timestamp: Date.today - days) } 
        (0..3).each { FactoryGirl.create(:done_story, type_of_work: "Inserted", timestamp: Date.today - days) } 
      end
    end 
    subject { DoneStory.select_yesterdays_weather }
    
    it { should == {Date.today - 12.days => {:timestamp=>Date.today - 12.days, 
                                            :effort=>{"Committed"=>{:type=>"Committed", :estimate=>4.0, :stories=>4}, 
                                              "Contingent"=>{:type=>"Contingent", :estimate=>4.0, :stories=>4}, 
                                              "Inserted"=>{:type=>"Inserted", :estimate=>4.0, :stories=>4}}}, 
                    Date.today - 6.days =>  {:timestamp=>Date.today - 6.days, 
                                            :effort=>{"Committed"=>{:type=>"Committed", :estimate=>4.0, :stories=>4}, 
                                              "Contingent"=>{:type=>"Contingent", :estimate=>4.0, :stories=>4}, 
                                              "Inserted"=>{:type=>"Inserted", :estimate=>4.0, :stories=>4}}}, 
                    Date.today =>           {:timestamp=>Date.today, 
                                             :effort=>{"Committed"=>{:type=>"Committed", :estimate=>4.0, :stories=>4}, 
                                               "Contingent"=>{:type=>"Contingent", :estimate=>4.0, :stories=>4}, 
                                               "Inserted"=>{:type=>"Inserted", :estimate=>4.0, :stories=>4}}}} }

  end
  
  
end