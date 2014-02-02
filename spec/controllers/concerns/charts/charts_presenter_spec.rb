require 'spec_helper'


module Charts
  describe ChartsPresenter do
    include ChartsPresenter
  
    let(:date) { Date.today.end_of_week }
    let(:done_stories) do
      done_stories = [0,1.week,2.weeks].map do |weeks|
        [(0..3).map { FactoryGirl.build(:done_story, type_of_work: "Committed", timestamp: date - weeks, estimate: 2) } ,
        (0..3).map { FactoryGirl.build(:done_story, type_of_work: "Contingent", timestamp: date - weeks, estimate: 3) } ,
        (0..3).map { FactoryGirl.build(:done_story, type_of_work: "Inserted", timestamp: date - weeks, estimate: 4) } ]
      end.flatten
    end


    before do
      DoneStory.stub(done_stories_data:  done_stories)
    end 

    context "burn_up_rows" do
      let(:timestamp) { Time.now }
      let(:data) {  (0..3).map { |i| FactoryGirl.build(:burn_up, timestamp: timestamp - i.days) } }
      before { Charts::BurnUpChart.stub(current_burn_up_data: data) }
      subject { burn_up_rows(data) }
    
      it { should == [[timestamp, 16, 4], [timestamp - 1.day, 16, 4], [timestamp - 2.days, 16, 4], [timestamp - 3 .days, 16, 4]] }
    
    end
    context "long_term_trend_visualization_rows" do
    
      subject { long_term_trend_visualization_rows(10) }

      it { should == [[date - 2.weeks, 36.0, 12], [date - 1.week, 36.0, 12], [date, 36.0, 12]] }
    end

    context "yesterdays_weather_data_rows" do
    
      subject { yesterdays_weather_data_rows(:estimate, 3, ["Committed", "Contingent", "Inserted"]) }

      it { should == [[(date - 2.weeks).strftime("%F"), 8.0, 12.0, 16.0], [(date - 1.week).strftime("%F"), 8.0, 12.0, 16.0], [(date).strftime("%F"), 8.0, 12.0, 16.0]] }
    end
  end
end