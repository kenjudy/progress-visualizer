require 'spec_helper'

describe WebhooksController do
  
  context "burn_up" do
    let(:burnup_chart) { double(Charts::BurnUpChart).as_null_object }

    before { Charts::BurnUpChart.stub(current: burnup_chart) }

    subject { post :burn_up, format: "json" }

    its(:code) { should == "200" }
    its(:body) { should == "OK" }
    
    context "burnup data" do
      after { subject }

      it("updates") { expect(burnup_chart).to receive(:update).once }
      
    end
    
    context "option 'add'" do
      subject { get :burn_up_add }
      after { subject }
      it("calls add webhook") { expect(controller).to receive(:add_webhook).and_return(double.as_null_object) }
    end
        
    context "option 'delete'" do
      subject { get :burn_up_delete }
      after { subject }
      it("calls delete webhook") { expect(controller).to receive(:delete_webhook) }
    end
  end
end
