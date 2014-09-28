require 'spec_helper'

describe ContactFormController, type: :controller do
  context "new" do
    subject { get :new }
    its(:code) { should == "200" }
    
    context 'assigns type of inquiry' do
      before { get :new, type_of_inquiry: 'Suggestion' }
      subject { assigns(:contact_form) }
      its(:type_of_inquiry) { is_expected.to eq 'Suggestion' }
    end
  end

  context "create" do
    subject { get :create }
    its(:code) { should == "200" }
  end

end
