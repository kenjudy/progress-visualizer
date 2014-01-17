require 'spec_helper'

describe ChartsController do
  context "daily_burnup" do
    
    subject do
      get :daily_burnup
      response
    end
    
    its(:code) { "200" }
  end
end
