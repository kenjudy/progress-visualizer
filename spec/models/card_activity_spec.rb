require 'spec_helper'

describe CardActivity do
  
  subject { FactoryGirl.build(:card_activity) }
  
  its(:type) { should == "copyCard" }
  its(:agent) { should == "Ken Judy" }
  its(:to_html) { should == "<span class=\"agent\">Ken Judy</span> <span class=\"verb\">copied</span> <span class=\"direct-object card\">this card</span>" }
  its(:redundant?) { should be_false }
  
  context "timestamp" do
    let(:precision) { 0 }
    let(:timestamp) { DateTime.parse("2014-04-16T20:29:03.332Z").in_time_zone.strftime('%s').to_i } 
    subject { FactoryGirl.build(:card_activity).timestamp(precision) }
    
    it { should == timestamp.to_s }
    
    context "with rounding" do
      let(:precision) { 300 }
      it { should == (timestamp - timestamp % 300).to_s }
    end
  end
  
  context "addAttachmentToCard" do
    subject { FactoryGirl.build(:card_activity, :add_attachment_to_card) }
    its(:verb) { should == "attached" }
    its(:direct_object) { should == "attachment_file_name.jpg" }
  end

  context "addMemberToCard" do
    subject { FactoryGirl.build(:card_activity, :add_member_to_card) }
    its(:verb) { should == "added" }
    its(:direct_object) { should == "Joan Doe to this card" }
  end

  context "addChecklistToCard" do
    subject { FactoryGirl.build(:card_activity, :add_checklist_to_card) }
    its(:verb) { should == "added checklist" }
    its(:direct_object) { should == "Things to do" }
  end
  
  context "commentCard" do
    subject { FactoryGirl.build(:card_activity, :comment_card) }
    its(:verb) { should == "commented"}
    its(:direct_object) { should == "<p>Make a change</p>\n"}
  end
  
  context "createCard" do
    subject { FactoryGirl.build(:card_activity, :create_card) }
    its(:verb) { should == "created"}
    its(:direct_object) { should == "this card"}
  end
  
  context "copyCard" do
    subject { FactoryGirl.build(:card_activity, :copy_card) }
    its(:verb) { should == "copied"}
    its(:direct_object) { should == "this card"}
  end

  context "convertToCardFromCheckItem" do
    subject { FactoryGirl.build(:card_activity, :convert_to_card_from_check_item) }
    its(:verb) { should == "converted"}
    its(:direct_object) { should == "checklist item to card"}
  end

  context "deleteAttachmentFromCard" do
    subject { FactoryGirl.build(:card_activity, :delete_attachment_from_card) }
    its(:verb) { should == "deleted attachment"}
    its(:direct_object) { should == "attachment_file_name.jpg"}
  end

  context "moveCardFromBoard" do
    subject { FactoryGirl.build(:card_activity, :move_card_from_board) }
    its(:verb) { should == "moved card from board"}
    its(:direct_object) { should == "Current Sprint"}
  end

  context "moveCardToBoard" do
    subject { FactoryGirl.build(:card_activity, :move_card_to_board) }
    its(:verb) { should == "moved card to board"}
    its(:direct_object) { should == "Current Sprint"}
  end

  context "removeChecklistFromCard" do
    subject { FactoryGirl.build(:card_activity, :remove_checklist_from_card) }
    its(:verb) { should == "removed checklist"}
    its(:direct_object) { should == "Things to do"}
  end

  context "removeMemberFromCard" do
    subject { FactoryGirl.build(:card_activity, :remove_member_from_card) }
    its(:verb) { should == "removed"}
    its(:direct_object) { should == "Joan Doe from this card"}
  end

  context "updateCheckItemStateOnCard" do
    subject { FactoryGirl.build(:card_activity, :update_check_item_state_on_card) }
    its(:verb) { should == "updated checklist"}
    its(:direct_object) { should == "Things to do"}
    
    context "flags redundancy" do
      before { subject.previous_type = "updateCheckItemStateOnCard"} 
      its(:redundant?) { should be_true }
    end
  end
  
  context "updateCard" do
    
    context "move to list" do
      subject { FactoryGirl.build(:card_activity, :update_card_move_to_list) }
      its(:verb) { should == "moved this card from Old List to"}
      its(:direct_object) { should == "New List"}
    end

    context "raise priority" do
      subject { FactoryGirl.build(:card_activity, :update_card_raise_priority) }
      its(:verb) { should == "moved this card"}
      its(:direct_object) { should == "up in priority"}
    end

    context "lower priority" do
      subject { FactoryGirl.build(:card_activity, :update_card_lower_priority) }
      its(:verb) { should == "moved this card"}
      its(:direct_object) { should == "down in priority"}
    end
    
    context "priority change as part of move list" do
      subject { FactoryGirl.build(:card_activity, :update_card_priority_as_part_of_list_move) }
      its(:redundant?) { should be_true }
    end

    context "rename card" do
      subject { FactoryGirl.build(:card_activity, :update_card_rename) }
      its(:verb) { should == "renamed this card" }
      its(:direct_object) { should == "New name" }
    end

    context "change desc" do
      subject { FactoryGirl.build(:card_activity, :update_card_change_description) }
      its(:verb) { should == "changed the description to" }
      its(:direct_object) { should == "<p>This card is really about <strong>stuff</strong></p>\n" }
    end

    context "archive" do
      subject { FactoryGirl.build(:card_activity, :update_card_archive) }
      its(:verb) { should == "archived" }
      its(:direct_object) { should == "this card" }
    end

    context "unarchive" do
      subject { FactoryGirl.build(:card_activity, :update_card_unarchive) }
      its(:verb) { should == "unarchived" }
      its(:direct_object) { should == "this card" }
    end
    
  end
  
  context "activity stream groups in 5min increments" do
    let(:activities) { (0..3).map { |i| FactoryGirl.build(:card_activity, :update_card_change_description) }}
    before { activities.first.data["date"] = (DateTime.parse(activities.first.data["date"]) - 6.minutes).to_s}
    subject { CardActivity.activity_stream(activities) }
    it { should have(2).items }
    
    context "redundancy doesn't create empty values" do
      let(:activities) { (0..3).map { |i| FactoryGirl.build(:card_activity, :update_check_item_state_on_card) }}
      it { should have(1).item }
    end
  end
  
  context "timeline" do
    let(:lists) { ["Ready for Development", "In Development", "Ready for QA", "Ready for Signoff", "Done"]}
    let(:activities) { (0..4).map { |i| FactoryGirl.build(:card_activity, :update_card_move_to_list) } }
    let(:first_move_date) { DateTime.now }
    before do
      activities.reverse.each_with_index do |a, i| 
        a.data["date"] = (first_move_date - (6 - i).days).to_s
        a.data["data"]["listBefore"]["name"] = i > 0 ? lists[i-1] : "In Design"
        a.data["data"]["listAfter"]["name"] = lists[i] if i <= 4
      end
    end
    
    subject { CardActivity.timeline(activities) }
    it { should have(6).items}
    its(:first) { should == {:list=>"In Design", :start=> activities.last.date_time, :end=> activities.last.date_time}}
    context "last" do
      subject { CardActivity.timeline(activities).last }
      its([:list]) { should == "Done" }
    end
    
    context "starts with create_card" do
      let(:first) { FactoryGirl.build(:card_activity, :create_card) }
      before do 
        first.data["date"] = (first_move_date - 11.days).to_s
        activities[0] = first 
      end
      subject { CardActivity.timeline(activities.unshift(first) ).first }
      its([:start]) { should == first.date_time }
    end
    
    context "doesn't blow up with no acitivities" do
      let(:activities) { [] }
      it { should == [] }
    end
  end
end
