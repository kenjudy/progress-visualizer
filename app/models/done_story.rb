class DoneStory < ActiveRecord::Base
  
  def self.done_stories_data(range, include_current = false)
    offset = include_current ? 0 : 1.week
    DoneStory.order("timestamp").where('timestamp > ?', Date.today - range.weeks - offset).to_a
  end
end
