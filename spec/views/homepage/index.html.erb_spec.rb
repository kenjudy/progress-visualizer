require 'spec_helper'

describe "homepage/index", type: :view do
    
  subject { render }
  
  it { is_expected.to have_selector("a", text: "Demo") }
end