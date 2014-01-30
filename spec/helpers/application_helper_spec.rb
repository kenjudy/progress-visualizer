require 'spec_helper'

describe ApplicationHelper do
  
  context "active" do
    let(:request) { double("Request").as_null_object }
    before { request.stub(fullpath: charts_daily_burnup_path)}
    subject { active(charts_daily_burnup_path) }
    it { should == "active" }
    context "no match" do
      before { request.stub(fullpath: tables_overview_path)}
      it { should_not == "active" }
    end
  end
  
end