class DoneStory < ActiveRecord::Base
  
  def self.done_stories_data(range, include_current = false)
    beginning_of_iteration = Constants::CONFIG[:iteration_start]
    offset = include_current ? 0 : 1.week
    DoneStory.order("timestamp").where('timestamp > ? and timestamp <= ?', beginning_of_iteration - range.weeks - offset, beginning_of_iteration - offset).to_a
  end
end
