require 'spec_helper'

describe "help", type:  :feature, js: true do
  before { visit '/help' }

  subject { page }

  it { should have_content 'Step 1'   }

  context "more about the visualizations" do
    before { click_link 'Sign up now' }
    it { should have_content 'Sign up'}
  end
    
end