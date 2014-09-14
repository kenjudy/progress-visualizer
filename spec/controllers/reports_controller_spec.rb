require 'spec_helper'

describe ReportsController, type: :controller do

  let(:user_profile) { FactoryGirl.create(:user_profile)}

  context "performance summary" do
    context "not authenticated" do
      subject { get :performance_summary }

      its(:code) { should == "302" }

    end

    context "authenticated" do
      before { sign_in user_profile.user }
      let(:iteration) { nil }

      subject do
        VCR.use_cassette('controllers/performance_summary') do
          get :performance_summary, iteration: iteration
        end
      end

      its(:code) { should == "200" }

      context "optional date param" do
        let(:iteration) { "2014-03-04" }
        before { expect_any_instance_of(Factories::DoneStoryFactory).to receive(:for_iteration).with(iteration) }
        it("retrieves done stories for iteration") { subject }
      end
    end
  end
  
  context "sharing" do
    let(:expiration) { Time.now + 2.weeks }
    let(:report_sharing) { FactoryGirl.create(:report_sharing, user_profile: user_profile, expiration: expiration) }
    subject { get :sharing, guid: report_sharing.guid }
    
    its(:code) { should == "200" }
    
    context "expired share" do
      let(:expiration) { Time.now - 1.day }
      its(:code) { should == "410"}
    end
    
  end
  
  context "sharing_new" do
    before do
      SecureRandom.stub(uuid: "20327ab0-8260-4759-abfa-1d3ce2513d1e")
      sign_in user_profile.user
    end
    
    subject do
      VCR.use_cassette('controllers/reports_controller/bitly_save_link') do
        get :sharing_new, report: 'performance-summary'
      end
    end
    
    its(:code) { should == "302" }
    its("flash") { subject;expect(flash[:notice]).to include("This report will be shareable until ") }
    its("flash") { subject;expect(flash[:notice]).to include("http://bit.ly") }

    context "creates report_share" do
      before do
        VCR.use_cassette('controllers/reports_controller/bitly_save_link') do
          get :sharing_new, report: 'performance-summary'
        end
      end
      subject { ReportSharing.last }
      its(:expiration) { should == Time.local(Date.today.year, Date.today.month, Date.today.day) + 1.month }
      its(:url) { should == reports_performance_summary_url(user_profile.beginning_of_current_iteration.strftime("%Y-%m-%d")) }
    end
  end

end