require 'spec_helper'

describe "index", type:  :feature, js: true do
  before { visit '/' }

  subject { page }

  it { is_expected.to have_content 'ProgressVisualizer'   }

  context "get started", js: false do
    before { click_link 'Sign up - it\'s free' }
    it { is_expected.to have_content 'Sign in'}
  end
end