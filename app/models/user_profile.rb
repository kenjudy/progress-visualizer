require 'csv'

class UserProfile < ActiveRecord::Base
  include ModelToArrayConcern
  include IterationConcern
  
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
  
  def self.array_attributes
    %w(id user_id name default readonly_token current_sprint_board_id current_sprint_board_id_short backlog_lists done_lists labels_types_of_work duration start_day_of_week end_day_of_week start_hour end_hour created_at updated_at start_date)
  end

  def default_values
    self.duration ||= 7
    self.done_lists ||= "{}"
    self.backlog_lists ||= "{}"
  end
  
  def to_csv
    CSV.generate do |csv|
      csv << UserProfile.array_attributes
      csv << to_array
      child_data_to_csv(done_stories, csv)
      child_data_to_csv(burn_ups, csv)
    end
  end
  
  private
  
  def child_data_to_csv(enumerable, csv)
    if enumerable.any?
      csv << ["=" * 20]
      csv << [enumerable.first.class.name]
      csv << enumerable.first.class.array_attributes
      enumerable.each { |model| csv << model.to_array }
    end
  end
  
end