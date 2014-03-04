require 'spec_helper'

describe IterationConcern do
  include IterationConcern

  [ { start_day_of_week: 1, end_day_of_week: 5, start_hour: 9, end_hour: 23, end_day: 4 },
    { start_day_of_week: 1, end_day_of_week: 1, start_hour: 9, end_hour: 9, end_day: 7},
    { start_day_of_week: 1, end_day_of_week: 0, start_hour: 9, end_hour: 0, end_day: 6 } ].each do |hash|

    context "start #{hash[:start_day_of_week]} #{hash[:start_hour]} and end #{hash[:end_day_of_week]} #{hash[:end_hour]}" do
      let(:start_day_of_week) { hash[:start_day_of_week] }
      let(:end_day_of_week) { hash[:end_day_of_week] }
      let(:start_hour) { hash[:start_hour] }
      let(:end_hour) { hash[:end_hour] }
      let(:end_day) { hash[:end_day]}

      {"One week" => 7, "Two weeks" => 14, "Three weeks" => 21, "Four weeks" => 28}.each do |duration, days|
        context duration do
          let(:user_profile) { FactoryGirl.create(:user_profile, duration: days, 
                                                                 start_day_of_week: start_day_of_week, 
                                                                 end_day_of_week: end_day_of_week, 
                                                                 start_hour: start_hour, 
                                                                 end_hour: end_hour ) }
          context "end days" do
            subject { iteration_days(user_profile) }
            it { should == end_day + days - 7 }
          end
          
          context "current iteration" do
            let(:start) { Date.today.end_of_week.to_datetime - (7 - user_profile.start_day_of_week).days +  user_profile.start_hour.hours }                                                              
            context "beginning" do
              subject { beginning_of_current_iteration }
              it { should ==  Time.zone.local_to_utc(start) }
            end
            context "end" do
              subject { end_of_current_iteration }
              it { should ==  Time.zone.local_to_utc(start.to_date + (end_day + days - 7).days + user_profile.end_hour.hours) }
            end
          end
          
          context "any iteration" do
            let(:start) { Date.new(2014,2,10) + user_profile.start_hour.hours }
            context "beginning" do
              subject { beginning_of_iteration(Date.new(2014,2,11)) }
              it { should == Time.zone.local_to_utc(start) }
            end
            context "end" do
              subject { end_of_iteration(Date.new(2014,2,11)) }
              it { should == Time.zone.local_to_utc(start.to_date + (end_day + days - 7).days + user_profile.end_hour.hours) }
            end
          end
        end
      end
    end
  end
end