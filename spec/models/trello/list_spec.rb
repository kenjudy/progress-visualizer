require 'spec_helper'
require 'json'

require_relative 'json_data'


module Trello
  describe Trello::List do
    include JsonData

    subject { List.new(JSON.parse(list_json_string))}
    
    its(:id) { should == "524478cbd6c2a2ec3a0001d0" }
    its(:name) { should == "Ready for Development" }

  end
end