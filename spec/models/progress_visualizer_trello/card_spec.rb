require 'spec_helper'
require 'json'

module ProgressVisualizerTrello
  describe ProgressVisualizerTrello::Card do
    include JsonData


    let(:card_array_attributes) { %w(number estimate name last_known_state closed? date_last_activity due labels id id_short id_board short_link short_url url id_list list_name) }
    let(:user_profile) { FactoryGirl.create(:user_profile)}

    let(:card_id) do
      VCR.use_cassette('models/cards') do
        Card.find_by(user_profile: user_profile).last.id
      end
    end
    
    let(:card) do
      VCR.use_cassette('models/card') do
        Card.find(user_profile: user_profile, card_id: card_id)
      end
    end
    let(:card_arr) { card.to_array }

    subject { card }

    context "accepts json" do
      its(:data) { should be_instance_of(Hash) }
    end

    context "has list" do
      before { card.list = List.new({"name" => "ListName"}) }
      its(:list) { should be_instance_of(List) }
      its(:list_name) { should == "ListName" }
    end

    context "parses json" do
      its(:id) { should be_instance_of(String)}
      its(:closed?) { should be_false }
      its(:date_last_activity) { should be_instance_of(DateTime) }
      its(:description) { should be_instance_of(String) }

      its(:id_board) { should be_instance_of(String) }
      its(:id_list) { should be_instance_of(String) }
      its(:number) { should be_instance_of(Fixnum) }
      its(:name) { should be_instance_of(String) }
      its(:estimate) { should be_instance_of(Float) }
      its(:badges) { should have_at_least(1).item }
      its(:labels) { should be_instance_of(Array) }
      its(:short_url) { should =~ /https:\/\/trello.com\/c\/\w+/ }
      its(:url) { should =~ /https:\/\/trello.com\/c\/\w+\/\d+[\w-]/ }
      its(:user_profile) { should == user_profile }
    end

    context "outputs to array" do

      Card.array_attributes.each_with_index do |attribute, index|
        context attribute do
          let(:attr) { attribute }
          it { expect(card_arr[index]).to eql(attribute == "labels" ? card.labels.join(",") : card.send(attribute.to_sym)) }
        end

      end

    end

    context "has array attributes" do
      subject { Card.array_attributes }

      it { should == card_array_attributes }
    end
    
    context "activity" do
      subject do
        VCR.use_cassette('models/card_activity') do
          card.activity
        end
      end
      
      it { should have_at_least(1).item }
    end
    
    context "finders" do

      context "find card" do
        subject { card }
        
        it { should be_instance_of(Card) }
        its(:id) { should == card_id }
        
      end

      context "find cards for current board" do
        subject do
          VCR.use_cassette('models/cards') do
            Card.find_by(user_profile: user_profile)
          end
        end
        its(:first) { should be_instance_of(Card)}
      end
      
      context "find all cards for current board (include archived)" do
        subject do
          VCR.use_cassette('models/cards_all') do
            Card.find_by(user_profile: user_profile, all: true)
          end
        end
        its(:first) { should be_instance_of(Card)}
      end
    end
  end

end
