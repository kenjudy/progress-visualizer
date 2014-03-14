require 'spec_helper'

describe ContactFormHelper do
  context "options_for_type_of_inquiry" do
    subject { options_for_type_of_inquiry("Question") }
    it { should == "<option value=\"Help\">Help</option>\n<option selected=\"selected\" value=\"Question\">Question</option>\n<option value=\"Suggestion\">Suggestion</option>\n<option value=\"Other\">Other</option>" }
  end
end
