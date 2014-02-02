require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user, name: "Test Name", password: "foo", email: "test@foo.bar") }
  let(:mailer) { double.as_null_object }
  before { UserMailer.stub(forgot_password: mailer ) }
  
  context "logout" do
    before do
      session[:user] = "Joe"
      get :logout
    end
    subject { session[:user] }
    it { should be_nil }
  end
  
  context "forgot_password" do
    after { get :forgot_password, name: user.name }
    subject { mailer }
    
    it { should receive(:deliver).once }
    
  end
  
  context "delete" do
    let(:name) { user.name }

    subject do
      get :delete, name: name
      User.find_by(email: "test@foo.bar")
    end
    
    it { should be_nil }
  end
  
  [:delete, :forgot_password].each do |action|
    context "bad username" do
      let(:name) { "non-existant" }
      it("doesn't fail") { expect{get action, name: name}.to_not raise_error }
    
      context "returns 500" do
        subject  { get action, name: name }
        its(:code) { should == "500" }
      end
    end
  end

  context "create_submit" do
    before do
      post :create_submit, :user => { "name" => "Test Name", "password" => "foo", "email" => "test@foo.bar" } 
      controller.stub(check_credentials: true)
    end
    
    subject { User.find_by(email: "test@foo.bar") }
 
    #it { should_not be_nil }
  end
end
