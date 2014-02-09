module Tables
  class DoneStoriesTable
    extend ActiveSupport::Concern
    extend BaseVisualization
    
    def self.current
      @results = Rails.cache.fetch("#{Rails.env}::Tables::DoneStoriesTable.current", :expires_in => 5.minutes) do
        Tables::DoneStoriesTable.current_without_cache(adapter)
      end
    end
    

    def self.current_without_cache(adapter)
      board = adapter.request_board(adapter.current_sprint_board_properties[:id])
      types_of_work = adapter.current_sprint_board_properties[:labels_types_of_work]
      done_list_ids = adapter.current_sprint_board_properties[:done_lists].keys
      results = { week_of: beginning_of_current_iteration, lists: {}}
      total_stories = 0
      total_estimates = 0
      types_of_work.each do |type_of_work|
        cards = board.cards.select{ |card| card.labels.map { |label| label.has_value?(type_of_work) }.include?(true) && done_list_ids.include?(card.id_list) }
        if cards && !cards.empty?
          stories = cards.length
          estimates = 0
          cards.each { |card| estimates += card.estimate }
          results[:lists][type_of_work] = { cards: cards, stories: stories, estimates: estimates}
          total_stories += stories
          total_estimates += estimates
        end
      end
      results[:totals] = {total_stories: total_stories, total_estimates: total_estimates}
      return results
    end
    
    def self.update
      results = current
      results[:lists].keys.each do |type_of_work|
        results[:lists][type_of_work][:cards].each do |card|
          story = DoneStory.find_or_initialize_by(story_id: card.id_short.to_s)
          attribs = { type_of_work: type_of_work,
                     status: card.id_list,
                     story: card.name,
                     estimate: card.estimate }
          attribs.merge!({timestamp: beginning_of_current_iteration, iteration: beginning_of_current_iteration.strftime("%F")}) if story.timestamp.nil?
          story.update_attributes(attribs)
        end
      end
    end
  end
  
end