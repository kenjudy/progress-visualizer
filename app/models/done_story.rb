class DoneStory < ActiveRecord::Base
  
  def self.done_stories_data(range = 3)
    DoneStory.order("timestamp").where('timestamp > ?', Date.today - range.weeks - 1.week).to_a
  end
end
