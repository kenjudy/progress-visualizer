class DoneStory < ActiveRecord::Base
  extend Tables::TablesConcern

  alias_attribute :name, :story
  
  belongs_to :user_profile
        
  def self.create_or_update_from(user_profile, card, type_of_work, beginning_of_current_iteration)
    type_of_work = nil if type_of_work && type_of_work.empty?  
    story = DoneStory.find_or_initialize_by(user_profile: user_profile, story_id: card.id_short.to_s)
    attribs = { type_of_work: type_of_work,
               status: card.id_list,
               story: card.name,
               estimate: card.estimate }
    attribs.merge!({timestamp: beginning_of_current_iteration, iteration: beginning_of_current_iteration.strftime("%F")}) if story.timestamp.nil?
    story.update_attributes(attribs)
  end
end
