class BurnUp < ActiveRecord::Base
  
  def self.burn_up_data(start_datetime, end_datetime)
    BurnUp.where("timestamp > ? and timestamp <= ?", start_datetime, end_datetime)
  end
end
