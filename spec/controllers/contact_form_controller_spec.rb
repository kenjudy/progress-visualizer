require 'spec_helper'

describe ContactFormController, type: :controller do
  context "new" do
    subject { get :new }
    its(:code) { should == "200" }
  end

  context "create" do
    subject { get :create }
    its(:code) { should == "200" }
  end

end
