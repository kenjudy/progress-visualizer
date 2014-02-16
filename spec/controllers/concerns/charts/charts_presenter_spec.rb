require 'spec_helper'


module Charts
  describe ChartsPresenter do
    include ChartsPresenter
    include IterationConcern
  
    let(:user_profile) { FactoryGirl.create(:user_profile) }
    let(:date) { Date.today.end_of_week }

    let(:iteration_start) { beginning_of_current_iteration }

    let(:two_weeks_ago) { (iteration_start - 2.weeks + 1.day).to_date }
    let(:one_week_ago)  { (iteration_start - 1.weeks + 1.day).to_date }
    let(:this_week)     { (iteration_start + 1.day).to_date }

    before do
      [this_week, one_week_ago, two_weeks_ago].each do |weeks|
        (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: "Committed", estimate: 2, timestamp: weeks) } 
        (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: "Contingent", estimate: 3, timestamp: weeks) } 
        (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: "Inserted", estimate: 4, timestamp: weeks) } 
      end
    end 

    
    context "done_stories_data" do
      let(:include_current) { false }
      subject { done_stories_data(3, include_current) }
    
      its(:length) { should == 24 }
      its(:first) { should be_instance_of(DoneStory) }
      it("doesn't contain this iteration") { expect(subject.last.timestamp < iteration_start) }

      context "include current" do
        let(:include_current) { true }
        its(:length) { should == 36 }
        it("contains this iteration") { expect(subject.last.timestamp >= iteration_start) }
      end

    end

    context "burn_up_rows" do
      let(:timestamp) { Time.now }
      let(:data) {  (0..3).map { |i| FactoryGirl.build(:burn_up, user_profile: user_profile, timestamp: timestamp - i.days) } }
      #before { Charts::BurnUpChart.stub(current_burn_up_data: data) }
      subject { burn_up_rows(data) }
    
      it { should == [[timestamp, 16, 4], [timestamp - 1.day, 16, 4], [timestamp - 2.days, 16, 4], [timestamp - 3 .days, 16, 4]] }
    
    end

    context "long_term_trend_visualization_rows" do
      let(:include_current) { false }
      subject { long_term_trend_visualization_rows(10, include_current) }

      it { should == [[two_weeks_ago, 36.0, 12], [one_week_ago, 36.0, 12]] }
      
      context "include current" do
        let(:include_current) { true }

        it { should == [[two_weeks_ago, 36.0, 12], [one_week_ago, 36.0, 12], [this_week, 36.0, 12]] }
      end
    end

    context "yesterdays_weather_data_rows" do
      let(:include_current) { false }
      subject { yesterdays_weather_data_rows(:estimate, 3, ["Committed", "Contingent", "Inserted"], include_current) }
      it { should == [[(two_weeks_ago).strftime("%F"), 8.0, 12.0, 16.0], [(one_week_ago).strftime("%F"), 8.0, 12.0, 16.0]] }
      context "include current" do
        let(:include_current) { true }
        it { should == [[(two_weeks_ago).strftime("%F"), 8.0, 12.0, 16.0], [(one_week_ago).strftime("%F"), 8.0, 12.0, 16.0], [(this_week).strftime("%F"), 8.0, 12.0, 16.0]] }
      end        
    end
    
  end
    
end