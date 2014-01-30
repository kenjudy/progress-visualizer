class DoneStory < ActiveRecord::Base
  
  def self.select_done_stories(range = 3)
    data = {}
    records = DoneStory.select("timestamp, type_of_work, count(*) as stories, sum(estimate) as estimate").group("timestamp, type_of_work").order("timestamp").where('timestamp > ?', Date.today - range.weeks - 1.week)
    records.each do |record|
      timestamp = record["timestamp"]
      row = data[timestamp] || {timestamp: timestamp}

      effort = row[:effort] || {}
      effort[record["type_of_work"]] = {type: record["type_of_work"], estimate: record["estimate"], stories: record["stories"]}

      row[:effort] = effort
      data[timestamp] = row
    end
    return data
  end
end
