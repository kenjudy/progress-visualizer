class DoneStory < ActiveRecord::Base
  include ModelToArrayConcern
  
  alias_attribute :name, :story
  alias_attribute :id_short, :story_id

  belongs_to :user_profile

  def self.create_or_update_from(user_profile, card, type_of_work, beginning_of_current_iteration)
    type_of_work = nil if type_of_work && type_of_work.empty?
    story = DoneStory.find_or_initialize_by(user_profile: user_profile, story_id: card.id_short.to_s)
    attribs = { type_of_work: type_of_work,
               status: card.id_list,
               story: card.name.truncate(255, separator: ' '),
               estimate: card.estimate,
               card_id: card.id,
              label_names: card.label_names,
               list_name: card.list_name}
    attribs.merge!({timestamp: beginning_of_current_iteration, iteration: beginning_of_current_iteration.strftime("%F")}) if story.timestamp.nil?
    story.update_attributes(attribs)
  end
  
  def prior_iteration
    adjacent_iteration("<")
  end
  
  def next_iteration
    adjacent_iteration(">")
  end
  
  def short_url
  end

  private
  
  def adjacent_iteration(comparitor)
    results = user_profile.done_stories.where("iteration #{comparitor} ?", iteration).order(iteration: comparitor == "<" ? :desc : :asc).limit(1)
    results.any? ? results.first.iteration : nil
  end
end
