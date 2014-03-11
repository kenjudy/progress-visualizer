require 'spec_helper'


module Charts
  describe ChartsConcern do
    include ChartsConcern
    include IterationConcern
    
    let(:types_of_work) { "Committed,Contingent,Inserted" }
    let(:user_profile) { FactoryGirl.create(:user_profile, labels_types_of_work: types_of_work) }
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
      subject { burn_up_rows(data) }
    
      it { should == [[timestamp, 16, 4], [timestamp - 1.day, 16, 4], [timestamp - 2.days, 16, 4], [timestamp - 3 .days, 16, 4]] }
    
      context "has_non_zero_values" do
        let(:chart) { burn_up_chart_visualization({label: "Estimates", data:  data.map{ |burn_up| { timestamp: burn_up.timestamp, backlog: burn_up.backlog_estimates, done: burn_up.done_estimates} }}) }
        subject { has_non_zero_values(chart)}
        
        it { should be_true }
        
        context "no estimates" do
          let(:chart) { burn_up_chart_visualization({label: "Estimates", data:  data.map{ |burn_up| { timestamp: burn_up.timestamp, backlog: 0.0, done: 0.0} }}) }
          it { should be_false }
        end
      end
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
      let(:chart) { YesterdaysWeatherChart.new(user_profile, {weeks: 3, label: :estimate}) }

      subject { yesterdays_weather_data_rows(chart, include_current) }

      it { should == [[(two_weeks_ago).strftime("%F"), 8.0, 12.0, 16.0], [(one_week_ago).strftime("%F"), 8.0, 12.0, 16.0]] }
      
      context "include current" do
        let(:include_current) { true }
        it { should == [[(two_weeks_ago).strftime("%F"), 8.0, 12.0, 16.0], [(one_week_ago).strftime("%F"), 8.0, 12.0, 16.0], [(this_week).strftime("%F"), 8.0, 12.0, 16.0]] }
      end  
      
      context "no types_of_work" do
        let(:types_of_work) { nil }
        it { should == [[(two_weeks_ago).strftime("%F"), 36.0], [(one_week_ago).strftime("%F"), 36.0  ]] }
      end

      context "has_non_zero_values" do
        subject { has_non_zero_values(yesterdays_weather_visualization(chart)) }
        it { should be_true }
        
        context "no estimates" do
          before do
            DoneStory.destroy_all
            [this_week, one_week_ago, two_weeks_ago].each do |weeks|
              (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: "Committed", estimate: 0, timestamp: weeks) } 
              (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: "Contingent", estimate: 0, timestamp: weeks) } 
              (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: "Inserted", estimate: 0, timestamp: weeks) } 
            end
          end 
          it { should be_false }
        end
      end
    end
    
  end
    
end