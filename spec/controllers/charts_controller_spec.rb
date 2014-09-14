require 'spec_helper'
require 'json'

describe ChartsController, type: :controller do

  context "not authenticated" do
    subject { get :burn_up }

    its(:code) { should == "302" }

  end

  context "authenticated" do
    let(:user_profile) { FactoryGirl.create(:user_profile) }
    let(:user) { user_profile.user }

    before { sign_in user }

    context "burn_up" do
      let(:format) { :html }
      subject { get :burn_up, format: format }

      its(:code) { should == "200" }

      context "has data" do
        before { FactoryGirl.create(:burn_up, user_profile: user_profile, timestamp: user_profile.beginning_of_current_iteration + 1.day) }
        
        context "assigns" do
          before { subject }
          it { expect(assigns(:estimates_chart)).not_to be_nil }
          it { expect(assigns(:stories_chart)).not_to be_nil }
        end
      
        context "json" do
          let(:format) { :json }
          its(:code) { should == "200" }
          context "has estimates" do
            before { allow(controller).to receive_messages(has_non_zero_values: true) }
            it("contains estimate and story charts") { expect(JSON.parse(subject.body).keys).to eql ["estimates_chart", "stories_chart"] }
          end
        
          context "no estimates" do
            before { allow(controller).to receive_messages(has_non_zero_values: false) }
            it("contains story charts") { expect(JSON.parse(subject.body).keys).to eql ["stories_chart"] }
          end
        end
      
        context "with week param" do
          before do
            VCR.use_cassette('controllers/charts_controller') do
              get :burn_up, iteration: "2014-02-24"
            end
          end
          it { expect(assigns(:iteration)).to eq(Date.new(2014,2,24)) }
        end
      end
      
      context "no data" do
        before do
          allow_any_instance_of(Factories::BurnUpFactory).to receive(:burn_up_data).and_return([])
          subject
        end

        it { expect(flash.now[:notice]).to include("No burn up data.") }
      end
      context "between iterations" do
        before do
          allow_any_instance_of(UserProfile).to receive(:between_iterations).and_return(true)
          subject
        end

        it { expect(flash.now[:notice]).to eql "No burn up data. Next iteration starts at #{user_profile.beginning_of_current_iteration.strftime('%b %e, %l %p')}." }
      end
     end

    context "burn_up_reload" do
      let(:burn_up) { FactoryGirl.create(:burn_up, user_profile: user_profile)}
      before { sign_in burn_up.user_profile.user }

      before { burn_up }
      subject { get :burn_up_reload }

      its(:code) { should == "200" }
      its(:body) { should == { last_update: burn_up.timestamp }.to_json }
    end

    context "yesterdays_weather" do
      subject { get :yesterdays_weather }

      its(:code) { "200" }

      context "assigns" do
        before { subject }
        it { expect(assigns(:yesterdays_weather_estimate_chart)).not_to be_nil }
        it { expect(assigns(:yesterdays_weather_stories_chart)).not_to be_nil }
      end
    end

    context "long_term_trend" do
      subject { get :long_term_trend }

      its(:code) { should == "200" }

      context "assigns" do
        before { subject }
        it { expect(assigns(:long_term_trend_chart)).not_to be_nil }
      end
      context "optional week param" do
        let(:long_term_trend_rows) { [] }
        subject { get :long_term_trend, weeks: "3" }
        after { subject }
        it { expect(controller).to receive(:long_term_trend_visualization).with(long_term_trend_rows) }
      end

    end
  end
end

