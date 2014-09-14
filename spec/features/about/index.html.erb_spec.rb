require 'spec_helper'

describe "about", type:  :feature, js: false do
  before { visit '/about' }

  subject { page }

  it { is_expected.to have_content 'ProgressVisualizer'   }

  context "more about the visualizations" do
    before { click_link 'More about the visualizations' }
    it { is_expected.to have_content 'Start visualizing'}
  end
  

  context "get started" do
    before { click_link 'Get started' }
    it { is_expected.to have_content 'Sign in'}
  end
  
end