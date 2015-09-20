require 'spec_helper'
require 'json'

describe TablesController, type: :controller do
  let(:user_profile) { FactoryGirl.create(:user_profile) }
  let(:adapter) { TrelloAdapter.new(user_profile) }


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
      let(:format) { :html }
      subject do
        VCR.use_cassette('controllers/tables_controller') do
          get :done_stories, format: format
        end
      end

      its(:code) { should == "200" }
      
      context "csv" do
        let(:format) { :csv }
        it { expect(subject.body).to eq "list,id_short,name,estimate,labels,short_url\n" }
      end
    end

    context "todo stories" do
      let(:format) { :html }
      subject do
        VCR.use_cassette('controllers/tables_controller') do
          get :todo_stories, format: format
        end
      end

      its(:code) { should == "200" }
    end

  end
end