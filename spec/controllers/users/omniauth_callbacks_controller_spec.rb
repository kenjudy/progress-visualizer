require 'spec_helper'

describe Users::OmniauthCallbacksController, type: :controller do
  let(:uid) { "uid" }
  let(:name) { "Ken" }
  let(:email) { "foo@bar.com"}
  

  context "trello" do
    let(:provider) { "trello" }
    let(:auth) { double("Auth", :[] => {}, slice: {provider: provider, uid: uid}, provider: provider, uid: uid, info: double("Info", email: "foo@bar.com", name: "Ken")) }
    let(:error_flash) { "Could not authenticate you from Trello because:<ul><li>Email can't be blank</li>\n<li>Name can't be blank</li></ul>Note: If you're using Google to sign into Trello, use Google to sign in to Progress Visualizer." }
    
    it_behaves_like("an omniauth provider")
  end
  
  context "twitter" do
    let(:provider) { "twitter" }
    let(:auth) { double("Auth", :[] => {}, slice: {provider: provider, uid: uid}, provider: provider, uid: uid, info: double("Info", name: "Ken")) }
    let(:error_flash) { "Could not authenticate you from Twitter because:<ul><li>Email can't be blank</li>\n<li>Name can't be blank</li></ul>" }
    let(:email) { "#{uid}@twitter.com"}
    
    it_behaves_like("an omniauth provider")
  end

  context "google_oauth2" do
    let(:provider) { "google_oauth2" }
    let(:auth) { double("Auth", :[] => {}, slice: {provider: provider, uid: uid}, provider: provider, uid: uid, name: name, email: email) }
    let(:error_flash) { "Could not authenticate you from Google Oauth2 because:<ul><li>Email can't be blank</li>\n<li>Name can't be blank</li></ul>" }
    
    it_behaves_like("an omniauth provider")
  end
  
end