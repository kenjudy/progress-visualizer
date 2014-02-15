require 'spec_helper'

describe UserProfilesHelper do
  let(:field) { "{\"5170058469d58225070003cc\":\"Ready for Development\",\"5170058469d58225070003cd\":\"In Progress\",\"51e44c8a29ef12da5d00028c\":\"Ready for QA\",\"520a5526d0aa033e6f00244e\":\"In QA\"}" }
  context "display_values" do
    subject { display_keys(field) }
    it {should == "Ready for Development,In Progress,Ready for QA,In QA"}
  end
end