require 'spec_helper'

describe ApplicationHelper do
  let(:request) { double("Request", fullpath: homepage_path).as_null_object }
  
  context "duration_in_weeks" do
    {"One week" => 7,"Two weeks" => 14, "Three weeks" => 21, "Four weeks" => 28}.each do |label, days|
      context "#{label}" do
        let(:label) { label }
        let(:days) { days }
        subject { duration_in_weeks(days) }
        
        it { should == label }
        
      end
    end
    context "days is nil" do
      subject { duration_in_weeks(nil) }
      it { should == "One week"}
    end
  end
  
  context "underscore_join_words" do
    subject { underscore_join_words("Done Stories") }
    
    it { should == "'done_stories'"}
    
    context "strip quote" do
      subject { underscore_join_words("Yesterday's Weather") }
    
      it { should == "'yesterdays_weather'"}
    end
  end
  
  context "menu_list_item" do
    subject { menu_list_item("Burn Up<span></span>", charts_burn_up_path) }
    
    it { should == "<li class=\" \"><a href=\"/chart/burn-up\" onClick=\"_gaq.push([&#39;_trackEvent&#39;, &#39;header_menu&#39;, &#39;burn_up&lt;span&gt;&lt;/span&gt;&#39;]);\">Burn Up<span></span></a></li>" }
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
  
  context "time_options" do
    subject { time_options(10) }
    it { should =~ /<option selected="selected" value="10">10 AM<\/option>/}
  end
end