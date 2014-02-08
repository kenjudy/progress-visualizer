class BurnUp < ActiveRecord::Base
  after_save :last_update
  
  def last_update
    Rails.cache.write(BurnUp.last_update_key, timestamp, :expires_in => 1.day)
  end
  
  def self.burn_up_data(start_datetime, end_datetime)
    BurnUp.where("timestamp > ? and timestamp <= ?", start_datetime, end_datetime)
  end
  
  def self.last_update_key
    "BurnUp::LastUpdate::#{"ken.judy".gsub(".","")}"
  end
  
end
