class DoneStory < ActiveRecord::Base
  
  def self.done_stories_data(range, include_current = false)
    offset = include_current ? 0 : 1.week
    DoneStory.order("timestamp").where('timestamp > ? and timestamp <= ?', Rails.application.config.iteration_start - range.weeks - offset, Rails.application.config.iteration_end - offset).to_a
  end
  
  def self.create_or_update_from(card, type_of_work, beginning_of_current_iteration)  
    story = DoneStory.find_or_initialize_by(story_id: card.id_short.to_s)
    attribs = { type_of_work: type_of_work,
               status: card.id_list,
               story: card.name,
               estimate: card.estimate }
    attribs.merge!({timestamp: beginning_of_current_iteration, iteration: beginning_of_current_iteration.strftime("%F")}) if story.timestamp.nil?
    story.update_attributes(attribs)
  end
  
end
