require 'spec_helper'
require 'json'

module ProgressVisualizerTrello
  describe ProgressVisualizerTrello::List do
    include JsonData

    subject { List.new(example_list_data)}
    
    its(:id) { should == "52653272e6fa31217b001705" }
    its(:name) { should == "Ready for Development" }

  end
end