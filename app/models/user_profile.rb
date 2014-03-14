class UserProfile < ActiveRecord::Base
  belongs_to :user

  has_many :done_story, :dependent => :delete_all
  has_many :burn_up, :dependent => :delete_all
  has_many :webhook, :dependent => :delete_all

  attr_encryptor :readonly_token, :current_sprint_board_id, :current_sprint_board_id_short, :backlog_lists, :done_lists, key: 'eovnpsimvkzrahjmhoqgyeoqngabrkemoexkmzuqiqvepfqmcq'

  alias_attribute :burn_ups, :burn_up
  alias_attribute :done_stories, :done_story
  alias_attribute :webhooks, :webhook

  validate :validate_start_date

  before_save :default_values

  def validate_start_date
    errors.add("Start date", "must not be in the future.") unless start_date.nil? || start_date <= Time.now
  end

  def default_values
    self.duration ||= 7
    self.done_lists ||= "{}"
    self.backlog_lists ||= "{}"
  end
end