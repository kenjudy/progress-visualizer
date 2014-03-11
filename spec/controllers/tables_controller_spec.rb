require 'spec_helper'
require 'json'

describe TablesController do
  let(:user_profile) { FactoryGirl.create(:user_profile) }
  let(:adapter) { Adapters::TrelloAdapter.new(user_profile) }


  context "not authenticated" do
    
    context "done stories" do
      subject { get :done_stories }
  
      its(:code) { should == "302" }

    end
  
    context "todo stories" do
      subject { get :todo_stories }
  
      its(:code) { should == "302" }

    end
  end
  
  context "authenticated" do
    before { sign_in user_profile.user }

    context "done stories" do
      subject do
        VCR.use_cassette('controllers/tables_controller') do
          get :done_stories
        end
      end
  
      its(:code) { should == "200" }
    end

    context "todo stories" do
      subject do
        VCR.use_cassette('controllers/tables_controller') do
          get :todo_stories
        end
      end
  
      its(:code) { should == "200" }
    end

  end
end