require 'spec_helper'

describe "index", type:  :feature, js: true do
  before { visit '/' }

  subject { page }

  it { should have_content 'ProgressVisualizer'   }

  context "get started" do
    before { click_link 'Get started' }
    it { should have_content 'Sign in'}
  end
end