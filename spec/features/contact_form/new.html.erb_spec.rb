require 'spec_helper'

describe "contact_form", type:  :feature, js: false do
  before { visit '/contact_form/new' }

  subject { page }

  it { should have_content 'Questions / Feedback'   }
  
  context "validations" do
    before { click_button 'Send Email' }
    it { should have_content 'Sorry, there are errors'}
    it { should have_content 'Name can\'t be blank'}
    it { should have_content 'Email can\'t be blank'}
  end
  
  context "form submit" do
    before do
      fill_in('Name', with: 'Ken')
      fill_in('Email', with: 'progressvisualizer@judykat.com')
      select('Other', from: "contact_form_type_of_inquiry")
      fill_in('Message', with: "Testing")
      click_button 'Send Email'
    end
    
    it { should have_content "Thank you for your message" }
  end
end