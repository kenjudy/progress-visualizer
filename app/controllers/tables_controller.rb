class TablesController < ApplicationController
  
  def overview
    @results = Tables::OverviewTable.current
  end
  
  def overview_by_status
    done_list_ids = @@adapter.current_sprint_board_properties[:done_list_ids]
    @results = { lists: {}}
    total_stories = 0
    total_estimates = 0
    done_list_ids.each do |list_id|
      list = board.lists.select { |list| list.id == list_id }.first
      cards = board.cards.select{ |card| card.id_list == list_id } 
      if list
        stories = cards.length
        estimates = 0
        cards.each { |card| estimates += card.estimate }
        @results[:lists][list.name] = { cards: cards, stories: stories, estimates: estimates}
        total_stories += stories
        total_estimates += estimates
      end
    end
    @results[:totals] = {total_stories: total_stories, total_estimates: total_estimates}
  end
end
