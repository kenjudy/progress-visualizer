class ReportSharing < ActiveRecord::Base
  belongs_to :user_profile

  after_initialize :set_guid
  
  validates :url, :expiration, :guid, presence: true
  validates :guid, uniqueness: true

  private
  
  def set_guid
    self.guid ||= SecureRandom.uuid
  end
end