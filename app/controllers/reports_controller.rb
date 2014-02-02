class ReportsController < ApplicationController
  include Authentication
  
  before_filter :user_authenticate
  
  def performance_summary
    
  end
  
end
  
