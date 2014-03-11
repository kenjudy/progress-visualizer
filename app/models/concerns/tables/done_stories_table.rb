module Tables
  class DoneStoriesTable
    extend ActiveSupport::Concern
    include UserProfileConcern
    include IterationConcern
    
    def initialize(user_profile)
      @user_profile = user_profile
    end
    
    def current
      
      @results = Rails.cache.fetch("#{Rails.env}::Tables::DoneStoriesTable.current:user#{@user_profile.user.id}:profile#{@user_profile.id})", :expires_in => 5.minutes) do
        refresh
      end
    end
    
    def refresh
      board = Adapters::BaseAdapter.build_adapter(user_profile).request_board(user_profile.current_sprint_board_id)
      collated_data = collate(board,
                              user_profile.labels_types_of_work.split(","), 
                              JSON.parse(user_profile.done_lists).keys)
      update_done_stories_for(collated_data)
    end
    
    def update_done_stories_for(collated_data)
      collated_data[:lists].keys.each do |type_of_work|
        collated_data[:lists][type_of_work][:cards].each do |card|
          DoneStory.create_or_update_from(@user_profile, card, type_of_work, beginning_of_current_iteration)
        end
      end
      return collated_data
    end
    
    def collate(board, types_of_work, done_list_ids)
      results = { week_of: beginning_of_current_iteration.strftime("%B %l, %Y"), lists: {}}
      results[:totals] = {total_stories: 0, total_estimates: 0}
      if types_of_work.any?
        types_of_work.each do |type_of_work|
          totals_by_type(board, done_list_ids, results, type_of_work)
        end
      else
        totals_by_type(board, done_list_ids, results)
      end
      return results
    end
    
    private
    
    def totals_by_type(board, done_list_ids, results, type_of_work = "") 
      unless type_of_work.empty?
        cards = board.cards.select{ |card| card.labels.map { |label| label.has_value?(type_of_work) }.include?(true) && done_list_ids.include?(card.id_list) }
      else
        cards = board.cards.select{ |card| done_list_ids.include?(card.id_list) }
      end
      if cards && !cards.empty?
        stories = cards.length
        estimates = 0
        cards.each { |card| estimates += card.estimate }
        results[:lists][type_of_work] = { cards: cards, stories: stories, estimates: estimates}
        results[:totals][:total_stories] += stories
        results[:totals][:total_estimates] += estimates
      end
    end
    
  end
  
end