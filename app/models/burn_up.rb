class BurnUp < ActiveRecord::Base
  after_save :last_update
  belongs_to :user_profile
  
  def last_update
    Rails.cache.write(BurnUp.last_update_key, timestamp, :expires_in => 1.day)
  end
  
  def self.last_update_key
    "BurnUp::LastUpdate::#{"ken.judy".gsub(".","")}"
  end
  
end
