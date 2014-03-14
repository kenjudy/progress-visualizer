require 'spec_helper'

describe "index", type:  :feature, js: true do
  before { visit '/' }

  subject { page }

  it { should have_content 'ProgressVisualizer'   }

  context "has learn more" do
    before { click_link 'Learn more' }
    it { should have_content 'About ProgressVisualizer'}
  end

  context "has get started" do
    before { click_link 'Get started' }
    it { should have_content 'Sign in'}
  end
end