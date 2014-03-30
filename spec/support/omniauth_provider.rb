shared_examples "an omniauth provider" do
  let(:notice) { "You successfully authenticated from #{provider.titleize}." }
  before do
    @request.env["omniauth.auth"] = auth
    @request.env["devise.mapping"] = Devise.mappings[:user]
    get provider
  end
  
  context "new user"  do
    subject { User.last }
    its(:provider) { should == provider }
    its(:uid) { should == uid }
    its(:name) { should == name }
    its(:email) { should == email }
    it("flashes success") { expect(flash[:notice]).to eql notice }
  end
  
  context "existing user" do
    let(:user) { FactoryGirl.create(:user, uid: uid, provider: provider) }
    it("flashes success") { expect(flash[:notice]).to eql notice }
  end
  
  context "fail" do
    let(:auth) { double("Auth").as_null_object }
    it("flashes error") { expect(flash[:error]).to eql error_flash }
  end
  
end
