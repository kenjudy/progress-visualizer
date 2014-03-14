require 'spec_helper'

describe UserProfile do

  context "encrypted attributes" do
    [:readonly_token, :current_sprint_board_id,
     :current_sprint_board_id_short, :backlog_lists,
     :done_lists].each do |attribute|
       let(:up) { UserProfile.new }
       let(:user) { FactoryGirl.create(:user) }

       context attribute.to_s do
         subject do
           up.user = user
           up.send("#{attribute}=", "foo")
           up.save
           UserProfile.find(up.id)
         end

         its("#{attribute}".to_sym) { should == "foo" }
         its("encrypted_#{attribute}".to_sym) { should_not be_nil }
         its("encrypted_#{attribute}_salt".to_sym) { should_not be_nil }
         its("encrypted_#{attribute}_iv".to_sym) { should_not be_nil }
       end

     end
  end

  context "default values" do
    before { UserProfile.new(user: FactoryGirl.create(:user)).save }

    subject { UserProfile.first }

    its(:backlog_lists) { should == "{}"}
    its(:done_lists) { should == "{}"}
    its(:duration) { should == 7}
  end
end