module Tables
  class DoneStoriesTable
    extend ActiveSupport::Concern
    extend IterationConcern
    
    def self.current
      @results = Rails.cache.fetch("#{Rails.env}::Tables::DoneStoriesTable.current", :expires_in => 5.minutes) do
        Tables::DoneStoriesTable.refresh
      end
    end
    
    def self.refresh
      collated_data = collate(adapter.request_board(adapter.current_sprint_board_properties[:id]),
                              adapter.current_sprint_board_properties[:labels_types_of_work], 
                              adapter.current_sprint_board_properties[:done_lists].keys)
      update_done_stories_for(collated_data)
    end
    
    def self.update_done_stories_for(collated_data)
      collated_data[:lists].keys.each do |type_of_work|
        collated_data[:lists][type_of_work][:cards].each do |card|
          DoneStory.create_or_update_from(card, type_of_work, beginning_of_current_iteration)
        end
      end
      return collated_data
    end
    
    def self.collate(board, types_of_work, done_list_ids)
      results = { week_of: beginning_of_current_iteration.strftime("%B %l, %Y"), lists: {}}
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

  end
  
end