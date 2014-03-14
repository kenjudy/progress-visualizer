require 'spec_helper'

describe IterationConcern do
  include IterationConcern

  [ { duration: 7, start_day_of_week: 1, end_day_of_week: 5, start_hour: 10, end_hour: 23, start_date: nil,
      it_p: DateTime.parse("Mon, 24 Feb 2014 10:00:00 EST -05:00"),
      it_s: DateTime.parse("Mon, 03 Mar 2014 10:00:00 EST -05:00"),
      it_e: DateTime.parse("Fri, 07 Mar 2014 23:00:00 EST -05:00"),
      dt_b: DateTime.parse("Sun, 02 Mar 2014 08:00:00 EST -05:00"),
      dt_m: DateTime.parse("Tue, 04 Mar 2014 08:00:00 EST -05:00")
     },
     { duration: 14, start_day_of_week: 1, end_day_of_week: 1, start_hour: 9, end_hour: 7, start_date: DateTime.parse("Mon, 03 Feb 2014 09:00:00 EST -05:00").to_date,
       it_p: DateTime.parse("Mon, 17 Feb 2014 09:00:00 EST -05:00"),
       it_s: DateTime.parse("Mon, 03 Mar 2014 09:00:00 EST -05:00"),
       it_e: DateTime.parse("Mon, 17 Mar 2014 07:00:00 EST -05:00"),
       dt_b: DateTime.parse("Mon, 03 Mar 2014 08:00:00 EST -05:00"),
       dt_m: DateTime.parse("Tue, 04 Mar 2014 08:00:00 EST -05:00")
      },
     { duration: 14, start_day_of_week: 1, end_day_of_week: 1, start_hour: 9, end_hour: 7, start_date: DateTime.parse("Mon, 10 Feb 2014 09:00:00 EST -05:00").to_date,
       it_p: DateTime.parse("Mon, 10 Feb 2014 09:00:00 EST -05:00"),
       it_s: DateTime.parse("Mon, 24 Feb 2014 09:00:00 EST -05:00"),
       it_e: DateTime.parse("Mon, 10 Mar 2014 07:00:00 EST -05:00"),
       dt_b: DateTime.parse("Mon, 10 Feb 2014 08:00:00 EST -05:00"),
       dt_m: DateTime.parse("Tue, 04 Mar 2014 08:00:00 EST -05:00")
      },
     { duration: 28, start_day_of_week: 1, end_day_of_week: 1, start_hour: 9, end_hour: 7, start_date: DateTime.parse("Mon, 03 Feb 2014 09:00:00 EST -05:00").to_date,
       it_p: DateTime.parse("Mon, 03 Feb 2014 09:00:00 EST -05:00"),
       it_s: DateTime.parse("Mon, 03 Mar 2014 09:00:00 EST -05:00"),
       it_e: DateTime.parse("Mon, 31 Mar 2014 07:00:00 EST -05:00"),
       dt_b: DateTime.parse("Mon, 03 Mar 2014 08:00:00 EST -05:00"),
       dt_m: DateTime.parse("Tue, 04 Mar 2014 08:00:00 EST -05:00")
      }
  ].each do |scenario|
    context "#{scenario[:dt_b].strftime("%m/%d/%Y %I:%M%p")}:  start: #{scenario[:start_day_of_week]} #{scenario[:start_hour]} end: #{scenario[:end_day_of_week]} #{scenario[:end_hour]} duration: #{scenario[:duration]} began #{scenario[:start_date].strftime("%m/%d/%Y") if scenario[:start_date]}" do
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
      let(:date_before) { scenario[:dt_b] }
      let(:date_mid) { scenario[:dt_m] }

      context "beginning_of_iteration" do
        subject { beginning_of_iteration(date_mid) }
        it { should == it_start }
      end

      context "end_of_iteration" do
        subject { end_of_iteration(date_mid) }
        it { should == it_end }
      end

      context "between_iterations" do
        let(:date) { date_before }
        subject { between_iterations(date) }
        it { should be_true }

        context "with #{scenario[:dt_m].strftime("%m/%d/%Y %I:%M%p")} iteration" do
          let(:date) { date_mid }
          it { should be_false }
        end
      end

      context "beginning_of_current_iteration" do
        subject { beginning_of_current_iteration }
        it { should == beginning_of_iteration(Date.today) }
      end

      context "end_of_current_iteration" do
        subject { end_of_current_iteration }
        it { should == end_of_iteration(Date.today) }
      end
    end
  end
end