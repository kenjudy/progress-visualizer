require 'spec_helper'

describe "help", type:  :feature, js: false do
  before { visit '/help' }

  subject { page }

  it { is_expected.to have_content 'Step 1'   }

  context "more about the visualizations" do
    before { click_link 'Sign up now' }
    it { is_expected.to have_content 'Sign up'}
  end
    
end