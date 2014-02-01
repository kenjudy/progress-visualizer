require 'spec_helper'

describe ApplicationHelper do
  
  context "active" do
    let(:request) { double("Request").as_null_object }
    before { request.stub(fullpath: charts_burn_up_path)}
    subject { active(charts_burn_up_path) }
    it { should == "active" }
    context "no match" do
      before { request.stub(fullpath: tables_overview_path)}
      it { should_not == "active" }
    end
  end
  
  context "user panel" do
    before do
      helper.request = double("request").as_null_object
      session[:user] = "Joe"
    end
    subject { helper.user_panel.downcase }
    it { should include("logout") }
    it { should include("joe") }
  end
  
end