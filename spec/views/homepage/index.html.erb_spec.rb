require 'spec_helper'

describe "homepage/index", type: :view do
    
  subject { render }
  
  it { should have_selector("a", text: "Demo") }
end