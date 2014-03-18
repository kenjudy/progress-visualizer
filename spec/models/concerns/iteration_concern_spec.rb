require 'spec_helper'

describe IterationConcern do
  include IterationConcern

  [ { duration: 7, start_day_of_week: 1, end_day_of_week: 5, start_hour: 10, end_hour: 23, start_date: nil,
      it_p: DateTime.parse("Mon, 24 Feb 2014 10:00:00 EST -05:00"),
      it_s: DateTime.parse("Mon, 03 Mar 2014 10:00:00 EST -05:00"),
      it_e: DateTime.parse("Fri, 07 Mar 2014 23:00:00 EST -05:00"),
      it_n: DateTime.parse("Mon, 10 Mar 2014 10:00:00 EST -04:00"),
      dt_b: DateTime.parse("Sun, 02 Mar 2014 08:00:00 EST -05:00"),
      dt_m: DateTime.parse("Tue, 04 Mar 2014 08:00:00 EST -05:00")
     },
     { duration: 7, start_day_of_week: 1, end_day_of_week: 0, start_hour: 10, end_hour: 23, start_date: nil,
       it_p: DateTime.parse("Mon, 24 Feb 2014 10:00:00 EST -05:00"),
       it_s: DateTime.parse("Mon, 03 Mar 2014 10:00:00 EST -05:00"),
       it_e: DateTime.parse("Sun, 09 Mar 2014 23:00:00 EST -05:00"),
       it_n: DateTime.parse("Mon, 10 Mar 2014 10:00:00 EST -04:00"),
       dt_b: DateTime.parse("Mon, 03 Mar 2014 08:00:00 EST -05:00"),
       dt_m: DateTime.parse("Sun, 09 Mar 2014 22:59:00 EST -05:00")
      },
     { duration: 14, start_day_of_week: 1, end_day_of_week: 1, start_hour: 9, end_hour: 7, start_date: DateTime.parse("Mon, 03 Feb 2014 09:00:00 EST -05:00").to_date,
       it_p: DateTime.parse("Mon, 17 Feb 2014 09:00:00 EST -05:00"),
       it_s: DateTime.parse("Mon, 03 Mar 2014 09:00:00 EST -05:00"),
       it_e: DateTime.parse("Mon, 17 Mar 2014 07:00:00 EST -04:00"),
       it_n: DateTime.parse("Mon, 17 Mar 2014 09:00:00 EST -04:00"),
       dt_b: DateTime.parse("Mon, 03 Mar 2014 08:00:00 EST -05:00"),
       dt_m: DateTime.parse("Tue, 04 Mar 2014 08:00:00 EST -05:00")
      },
     { duration: 14, start_day_of_week: 1, end_day_of_week: 1, start_hour: 9, end_hour: 7, start_date: DateTime.parse("Mon, 10 Feb 2014 09:00:00 EST -05:00").to_date,
       it_p: DateTime.parse("Mon, 10 Feb 2014 09:00:00 EST -05:00"),
       it_s: DateTime.parse("Mon, 24 Feb 2014 09:00:00 EST -04:00"),
       it_e: DateTime.parse("Mon, 10 Mar 2014 07:00:00 EST -05:00"),
       it_n: DateTime.parse("Mon, 10 Mar 2014 09:00:00 EST -05:00"),
       dt_b: DateTime.parse("Mon, 10 Feb 2014 08:00:00 EST -05:00"),
       dt_m: DateTime.parse("Tue, 04 Mar 2014 08:00:00 EST -05:00")
      },
     { duration: 28, start_day_of_week: 1, end_day_of_week: 1, start_hour: 9, end_hour: 7, start_date: DateTime.parse("Mon, 03 Feb 2014 09:00:00 EST -05:00").to_date,
       it_p: DateTime.parse("Mon, 03 Feb 2014 09:00:00 EST -05:00"),
       it_s: DateTime.parse("Mon, 03 Mar 2014 09:00:00 EST -05:00"),
       it_e: DateTime.parse("Mon, 31 Mar 2014 07:00:00 EST -04:00"),
       it_n: DateTime.parse("Mon, 31 Mar 2014 09:00:00 EST -04:00"),
       dt_b: DateTime.parse("Mon, 03 Mar 2014 08:00:00 EST -05:00"),
       dt_m: DateTime.parse("Tue, 04 Mar 2014 08:00:00 EST -05:00")
      }
  ].each_with_index do |scenario, index|
    context "#{index}: #{scenario[:it_s].strftime("%a, %m/%d/%Y %I:%M%p")} - #{scenario[:it_e].strftime("%a, %m/%d/%Y %I:%M%p")}" do
      let(:user_profile) { FactoryGirl.create(:user_profile, duration: scenario[:duration],
                                                             start_day_of_week: scenario[:start_day_of_week],
                                                             end_day_of_week: scenario[:end_day_of_week],
                                                             start_hour: scenario[:start_hour],
                                                             end_hour: scenario[:end_hour],
                                                             start_date: scenario[:start_date]
      ) }

      let(:it_prev) { scenario[:it_p] }
      let(:it_start) { scenario[:it_s] }
      let(:it_end) { scenario[:it_e] }
      let(:it_next) { scenario[:it_n] }
      let(:date_before) { scenario[:dt_b] }
      let(:date_mid) { scenario[:dt_m] }

      context "beginning_of_iteration #{scenario[:it_s].strftime("%a, %m/%d/%Y %I:%M%p")}" do
        subject { beginning_of_iteration(date_mid) }
        it { should == it_start }
      end

      context "end_of_iteration #{scenario[:dt_m].strftime("%a, %m/%d/%Y %I:%M%p")}" do
        subject { end_of_iteration(date_mid) }
        it { should == it_end }
      end

      context "between_iterations" do
        let(:date) { date_before }
        subject { between_iterations(date) }
        
        context "#{scenario[:dt_b].strftime("%a, %m/%d/%Y %I:%M%p")}" do
          it { should be_true }
        end

        context "#{scenario[:dt_m].strftime("%a, %m/%d/%Y %I:%M%p")}" do
          let(:date) { date_mid }
          it { should be_false }
        end
      end

      context "beginning_of_current_iteration #{Date.today.strftime("%a, %m/%d/%Y %I:%M%p")}" do
        subject { beginning_of_current_iteration }
        it { should == beginning_of_iteration(Date.today) }
      end

      context "end_of_current_iteration #{Date.today.strftime("%a, %m/%d/%Y %I:%M%p")}" do
        subject { end_of_current_iteration }
        it { should == end_of_iteration(Date.today) }
      end
      
      context "prior_iteration" do
        before do
          FactoryGirl.create(:done_story, user_profile: user_profile, iteration: it_start.to_date)
          FactoryGirl.create(:done_story, user_profile: user_profile, iteration: it_prev.to_date)
        end
        
        subject { prior_iteration(it_start.to_date) }
        it { should == it_prev.strftime("%Y-%m-%d") }
        
        context "nil defaults to current" do
          before do
            FactoryGirl.create(:done_story, user_profile: user_profile, iteration: beginning_of_current_iteration.to_date)
            FactoryGirl.create(:done_story, user_profile: user_profile, iteration: (beginning_of_current_iteration - user_profile.duration.days).to_date)
          end
          subject { prior_iteration(nil) }
          it { should == (beginning_of_current_iteration - user_profile.duration.days).strftime("%Y-%m-%d") }
        end
        
        context "between iteration returns DoneStory.last" do
          let(:date) { (beginning_of_current_iteration - user_profile.duration.days).to_date }
          before { FactoryGirl.create(:done_story, user_profile: user_profile, iteration: date) }
          subject { prior_iteration(nil) }
          it { should == date.strftime("%Y-%m-%d") }
        end
      end
      
      context "next_iteration" do
        before do
          FactoryGirl.create(:done_story, user_profile: user_profile, iteration: it_start.to_date)
          FactoryGirl.create(:done_story, user_profile: user_profile, iteration: it_next.to_date)
        end
        
        subject { next_iteration(it_start.to_date) }
        it { should == it_next.strftime("%Y-%m-%d") }
        
        context "nil defaults to current" do
          before do
            FactoryGirl.create(:done_story, user_profile: user_profile, iteration: beginning_of_current_iteration.to_date)
            FactoryGirl.create(:done_story, user_profile: user_profile, iteration: (beginning_of_current_iteration + user_profile.duration.days).to_date)
          end
          subject { next_iteration(nil) }
          it { should == (beginning_of_current_iteration + user_profile.duration.days).strftime("%Y-%m-%d") }
        end
      end

    end
  end
end