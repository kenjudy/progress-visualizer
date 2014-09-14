require 'spec_helper'

describe "Factories::DoneStoryFactory", :type => :model do
  
  let(:board) { FactoryGirl.build(:board, cards: cards) }
  let(:types_of_work) { ["Committed"] }
  let(:done_list_ids) { ["5170058469d58225070003ce"] }
  let(:user_profile) { FactoryGirl.create(:user_profile, labels_types_of_work: types_of_work.join(",")) }
  let(:done_story_factory) { Factories::DoneStoryFactory.new(user_profile) }

  let(:cards) do
    (0..1).map do |i|
      FactoryGirl.build(:card, id_short: "#{i}", id_list: "5170058469d58225070003ce", labels: [{color: "blue", name: "Committed"}], name: "(3) Foo #{i}")
    end
  end

  context "collated data" do
    let(:collated_data) { done_story_factory.collate(board, types_of_work, done_list_ids, "2014-03-04") }
    context "update_done_stories_for" do
      before { done_story_factory.update_done_stories_for(collated_data) }
      subject { DoneStory.all }
      its(:count) { should == 2}
    end
    context "to_csv" do
      subject { done_story_factory.to_csv(collated_data) }
      it do
        is_expected.to eq <<-EOF
list,id_short,name,estimate,short_url
Committed,0,Foo 0,3.0,https://trello.com/c/j56OGdXO
Committed,1,Foo 1,3.0,https://trello.com/c/j56OGdXO
EOF
      end
    end
  end

  context "for_iteration" do
    before do
      ["Committed", "Inserted", "Contingent"].each do |type_of_work|
        (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: type_of_work, estimate: 2, timestamp: "2014-03-04", status: JSON.parse(user_profile.done_lists).keys.first) }
        (0..3).each { FactoryGirl.create(:done_story, user_profile: user_profile, type_of_work: type_of_work, estimate: 2, timestamp: "2014-03-04", status: "NOT DONE") }
      end
    end
    subject { done_story_factory.for_iteration("2014-03-04") }

    its([:totals]) { should == {:total_stories=>4, :total_estimates=>8.0} }
    its([:lists]) { should have(1).item }

  end
end
