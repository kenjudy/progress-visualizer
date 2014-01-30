require 'spec_helper'

describe Charts::ChartsPresenter do
  include Charts::ChartsPresenter
  
  let(:date) { Date.today.end_of_week }
  before do
    DoneStory.stub(done_stories_data: {date - 2.weeks => {:timestamp=>date - 2.weeks, 
                                          :effort=>{"Committed"=>{:type=>"Committed", :estimate=>4.0, :stories=>4}, 
                                            "Contingent"=>{:type=>"Contingent", :estimate=>4.0, :stories=>4}, 
                                            "Inserted"=>{:type=>"Inserted", :estimate=>4.0, :stories=>4}}}, 
                  date - 1.week =>  {:timestamp=>date - 1.week, 
                                          :effort=>{"Committed"=>{:type=>"Committed", :estimate=>4.0, :stories=>4}, 
                                            "Contingent"=>{:type=>"Contingent", :estimate=>4.0, :stories=>4}, 
                                            "Inserted"=>{:type=>"Inserted", :estimate=>4.0, :stories=>4}}}, 
                  date =>           {:timestamp=>date, 
                                           :effort=>{"Committed"=>{:type=>"Committed", :estimate=>4.0, :stories=>4}, 
                                             "Contingent"=>{:type=>"Contingent", :estimate=>4.0, :stories=>4}, 
                                             "Inserted"=>{:type=>"Inserted", :estimate=>4.0, :stories=>4}}}} )
  end 

  context "burn_up_rows" do
    let(:timestamp) { Time.now }
    let(:data) {  (0..3).map { |i| FactoryGirl.build(:burn_up, timestamp: timestamp - i.days) } }
    before { Charts::BurnUpChart.stub(current_burn_up_data: data) }
    subject { burn_up_rows(data) }
    
    it { should == [[timestamp, 16, 4], [timestamp - 1.day, 16, 4], [timestamp - 2.days, 16, 4], [timestamp - 3 .days, 16, 4]] }
    
  end
  context "long_term_trend_visualization_rows" do
    
    subject { long_term_trend_visualization_rows }

    it { should == [[date - 2.weeks, 4.0, 4.0], [date - 1.week, 4.0, 4.0], [date, 4.0, 4.0]] }
  end

  context "yesterdays_weather_data_rows" do
    
    subject { yesterdays_weather_data_rows(:estimate, 3) }

    it { should == [[(date - 2.weeks).strftime("%F"), 4.0, 4.0, 4.0], [(date - 1.week).strftime("%F"), 4.0, 4.0, 4.0], [(date).strftime("%F"), 4.0, 4.0, 4.0]] }
  end
end