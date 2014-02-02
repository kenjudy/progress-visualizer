require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user, name: "Test Name", password: "foo", email: "test@foo.bar") }
  
  it "resets password" do
    password = user.password
    new_password = user.reset_password
    expect(password).to_not eql(new_password)
  end
  
  context  do
    it("reads null password") { expect{User.new.password}.to_not raise_error }
  end
 
end