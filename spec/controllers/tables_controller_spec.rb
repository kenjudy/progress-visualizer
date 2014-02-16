require 'spec_helper'
require 'json'

describe TablesController do
  include ProgressVisualizerTrello::JsonData


  context "done_stories" do
    let(:user_profile) { FactoryGirl.create(:user_profile) }
    let(:adapter) { Adapters::TrelloAdapter.new(user_profile) }
    
    context "not authenticated" do
      subject { get :done_stories }
  
      its(:code) { should == "302" }

    end
  
    context "authenticated" do
      before { sign_in user_profile.user }

      subject do
        VCR.use_cassette('controllers/controllers/tables_controller') do
          get :done_stories
        end
      end
    
      its(:code) { should == "200" }

    end
  end
end