class UserProfile < ActiveRecord::Base
  belongs_to :user

  has_many :done_story, :dependent => :delete_all
  has_many :burn_up, :dependent => :delete_all
  has_many :webhook, :dependent => :delete_all

  attr_encryptor :readonly_token, :current_sprint_board_id, :current_sprint_board_id_short, :backlog_lists, :done_lists, key: 'eovnpsimvkzrahjmhoqgyeoqngabrkemoexkmzuqiqvepfqmcq'
  
  alias :burn_ups :burn_up 
  alias :done_stories :done_story
  
  validate :validate_start_date
  

  def validate_start_date
    errors.add("Start date", "must not be in the future.") unless start_date.nil? || start_date <= Time.now
  end
end