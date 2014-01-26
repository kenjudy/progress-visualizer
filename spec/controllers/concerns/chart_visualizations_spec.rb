require 'spec_helper'

describe ChartVisualizations do
  include ChartVisualizations
  
  let(:date) { Date.today.end_of_week }
  before do
    DoneStory.stub(select_yesterdays_weather: {date - 2.weeks => {:timestamp=>date - 2.weeks, 
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

  context "long_term_trend_visualization_rows" do
    
    subject { long_term_trend_visualization_rows }

    it { should == [[date - 2.weeks, 4.0, 4.0], [date - 1.week, 4.0, 4.0], [date, 4.0, 4.0]] }
  end

  context "yesterdays_weather_data_rows" do
    
    subject { yesterdays_weather_data_rows(:estimate, 3) }

    it { should == [[(date - 2.weeks).strftime("%F"), 4.0, 4.0, 4.0], [(date - 1.week).strftime("%F"), 4.0, 4.0, 4.0], [(date).strftime("%F"), 4.0, 4.0, 4.0]] }
  end
end