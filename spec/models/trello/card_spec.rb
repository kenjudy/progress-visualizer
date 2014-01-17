require 'spec_helper'
require 'json'

require_relative 'json_data'


module Trello
  describe Trello::Card do
    include JsonData
  
  
    let(:card_json) { JSON.parse(card_json_string) }
    let(:card) { Card.new(card_json) }
    let(:card_arr) { card.to_array }
    let(:card_array_attributes) { %w(number estimate name last_known_state closed? date_last_activity due labels id id_board id_list short_link short_url url) }

    subject { card }
  
    context "accepts json" do
      its(:json) { should eql(card_json) }
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
          before { card_json["due"] = nil }
          it { expect{subject}.to_not raise_error }
        end

        context "checkItemStates" do
          before { card_json["checkItemStates"] = nil }
          it { expect{subject}.to_not raise_error }
        end
        context "checkItemStates last" do
          before { card_json["checkItemStates"] = [] }
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
  end
  
end
