require 'spec_helper'

describe "about", type:  :feature, js: true do
  before { visit '/about' }

  subject { page }

  it { should have_content 'ProgressVisualizer'   }

  context "more about the visualizations" do
    before { click_link 'More about the visualizations' }
    it { should have_content 'Start visualizing'}
  end
  

  context "get started" do
    before { click_link 'Get started' }
    it { should have_content 'Sign in'}
  end
  
end