require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user, name: "Test Name", password: "foo", email: "test@foo.bar") }
  
  context "logout" do
    before do
      session[:user] = "Joe"
      get :logout
    end
    subject { session[:user] }
    it { should be_nil }
  end
  
  context "forgot_password" do
    before do
     user 
     get :forgot_password, name: "Test Name"
   end
   subject { User.find_by(email: "test@foo.bar") }
   
   its(:password) { should_not == "foo" }
    
  end
  
  context "delete" do
    before do
      user 
      get :delete, name: "Test Name"
    end
    subject { User.find_by(email: "test@foo.bar") }
    
    it { should be_nil }
  end

  context "create_submit" do
    before { post :create_submit, :user => { "name" => "Test Name", "password" => "foo", "email" => "test@foo.bar" } }
    subject { User.find_by(email: "test@foo.bar") }
 
#TODO: can't get submit to happen    it { should_not be_nil }
  end
end
