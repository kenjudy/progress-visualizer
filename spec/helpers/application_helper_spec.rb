require 'spec_helper'

describe ApplicationHelper do
  let(:request) { double("Request", fullpath: homepage_path).as_null_object }
  
  context "menu_list_item" do
    subject { menu_list_item("Burn Up<span></span>", charts_burn_up_path) }
    
    it { should == '<li><a href="/chart/burn-up">Burn Up<span></span></a></li>'}
  end
  
  context "active class if" do

    subject { active_class_if(charts_burn_up_path) }

    context "match" do
      before { request.stub(fullpath: charts_burn_up_path)}
      it { should == "active" }
      
      context "multiple patha args" do
        subject { active_class_if([charts_burn_up_path, tables_done_stories_path]) }
        it { should == "active" }
      end
    end

    context "no match" do
      it { should_not == "active" }
    end

  end
  
  context "user panel" do

  end
  
end