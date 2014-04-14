require 'spec_helper'
require 'json'

module ProgressVisualizerTrello
  describe ProgressVisualizerTrello::Card do
    include JsonData


    let(:card_data) { example_card_data }
    let(:card) { Card.new(card_data) }
    let(:card_arr) { card.to_array }
    let(:card_array_attributes) { %w(number estimate name last_known_state closed? date_last_activity due labels id id_short id_board short_link short_url url id_list list_name) }

    subject { card }

    context "accepts json" do
      its(:data) { should eql(card_data) }
    end

    context "has list" do
      before { card.list = List.new({"name" => "ListName"}) }
      its(:list) { should be_instance_of(List) }
      its(:list_name) { should == "ListName" }
    end

    context "parses json" do
      its(:id) { should == "524478cbd6c2a2ec3a0001d0" }
      its(:last_known_state) { should == "complete" }
      its(:closed?) { should be_true }
      its(:date_last_activity) { should == Date.parse('2014-01-08T20:18:10.292Z')}
      its(:description) { should =~ /ADULT LIBRARIANS WILL BE FIRST/ }

      its(:id_board) { should == "5170058469d58225070003cb" }
      its(:id_list) { should == "52653272e6fa31217b001705" }
      its(:number) { should == 605 }
      its(:name) { should == ".NET Layout Setup (Adult Librarians)" }
      its(:estimate) { should == 2.5 }
      its(:short_link) { should == "j56OGdXO" }
      its(:badges) { should have(10).items }
      its(:due) { should == Date.parse('2014-01-08T20:18:10.292Z') }
      its(:labels) { should == [{"color"=>"yellow", "name"=>"Tech Stories"},{"color"=>"blue", "name"=>"Pimsleur"}] }
      its(:short_url) { should == "https://trello.com/c/j56OGdXO" }
      its(:url) { should == "https://trello.com/c/j56OGdXO/605-net-layout-setup-adult-librarians" }

      context "accepts null values" do

        context "due" do
          before { card_data["due"] = nil }
          it { expect{subject}.to_not raise_error }
        end

        context "checkItemStates" do
          before { card_data["checkItemStates"] = nil }
          it { expect{subject}.to_not raise_error }
        end
        context "checkItemStates last" do
          before { card_data["checkItemStates"] = [] }
          it { expect{subject}.to_not raise_error }
        end
      end
    end

    context "outputs to array" do

      Card.array_attributes.each_with_index do |attribute, index|
        context attribute do
          let(:attr) { attribute }
          it { expect(card_arr[index]).to eql(attribute == "labels" ? "Tech Stories,Pimsleur" : card.send(attribute.to_sym)) }
        end

      end

    end

    context "has array attributes" do
      subject { Card.array_attributes }

      it { should == card_array_attributes }
    end
    
    context "finders" do
      let(:user_profile) { FactoryGirl.create(:user_profile)}
      let(:include_archived) { false }
      subject do
        VCR.use_cassette('adapters/models/cards') do
          Card.find_by(user_profile: user_profile, all: include_archived)
        end
      end
      
      its(:first) { should be_instance_of(Card)}
      
      context "include archive" do
        let(:include_archived) { true }
        subject do
          VCR.use_cassette('adapters/models/cards_all') do
            Card.find_by(user_profile: user_profile, all: include_archived)
          end
        end
        its(:first) { should be_instance_of(Card)}
      end
    end
  end

end
