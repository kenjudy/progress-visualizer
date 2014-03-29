class ReportSharing < ActiveRecord::Base
  belongs_to :user_profile
  
  validates :url, :expiration, :guid, presence: true
  validates :guid, uniqueness: true

end