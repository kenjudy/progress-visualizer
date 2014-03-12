module Tables::TablesConcern
  extend ActiveSupport::Concern
  include IterationConcern
  include UserProfileConcern
  
      
  attr_accessor :user_profile

  def initialize(user_profile)
    @user_profile = user_profile
  end

  def cache_key
    "#{Rails.env}::#{self.class.name}.current:user#{user_profile.user.id}:profile#{@user_profile.id})"
  end
  
  def current
    @results = Rails.cache.fetch(cache_key, :expires_in => 5.minutes) do
      refresh
    end
  end
  
  def refresh
    raise "#{self.class.name} must implement refresh"
  end

  def request_and_collate_stories(lists)
    board = Adapters::BaseAdapter.build_adapter(user_profile).request_board(user_profile.current_sprint_board_id)
    collate(board,
            user_profile.labels_types_of_work.split(","), 
            JSON.parse(lists).keys)
  end
  
  def collate(board, types_of_work, list_ids, week_of_label = beginning_of_current_iteration.strftime("%B %l, %Y"))
    results = { week_of: week_of_label, lists: {}}
    results[:totals] = {total_stories: 0, total_estimates: 0}
    if types_of_work.any?
      types_of_work.each do |type_of_work|
        totals_by_type(board, list_ids, results, type_of_work)
      end
    else
      totals_by_type(board, list_ids, results)
    end
    return results
  end
  
  private
  
  def totals_by_type(collection, list_ids, results, type_of_work = "")
    if collection.respond_to?("cards")
      card_totals_by_type(collection, list_ids, results, type_of_work)
    else
      done_stories_totals_by_type(collection, list_ids, results, type_of_work)
    end
  end
  
  def done_stories_totals_by_type(done_stories, list_ids, results, type_of_work = "")
    return if done_stories.empty?

    unless type_of_work.empty?
      done_stories = done_stories.where("type_of_work = ?", type_of_work)
    end
    
    stories = done_stories.length
    estimates = sum_estimates(done_stories)
    results[:lists][type_of_work] = { cards: done_stories, stories: stories, estimates: estimates}
    results[:totals][:total_stories] += stories
    results[:totals][:total_estimates] += estimates
    
  end
  
  def card_totals_by_type(board, list_ids, results, type_of_work = "")
    unless type_of_work.empty?
      cards = board.cards.select{ |card| card.labels.map { |label| label.has_value?(type_of_work) }.include?(true) && list_ids.include?(card.id_list) }
    else
      cards = board.cards.select{ |card| list_ids.include?(card.id_list) }
    end
    if cards && !cards.empty?
      stories = cards.length
      estimates = sum_estimates(cards)
      results[:lists][type_of_work] = { cards: cards, stories: stories, estimates: estimates}
      results[:totals][:total_stories] += stories
      results[:totals][:total_estimates] += estimates
    end
  end
  
  def sum_estimates(stories)
    estimates = 0
    stories.each { |story| estimates += story.estimate }
    estimates
  end


end