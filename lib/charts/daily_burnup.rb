module Charts
  class DailyBurnup
    attr_accessor :done_lists, :backlog_lists, :timestamp

    def initialize(board, options = {})
      @board = board
      @timestamp = options[:timestamp] || Time.now
      @done_lists = options[:done_lists]
      @backlog_lists = options[:backlog_lists]
    end
    
    def current_progress
      { timestamp: timestamp, done: sum_estimates(@done_lists), backlog: sum_estimates(@backlog_lists) }
    end
    
    private
    
    def sum_estimates(lists)
      sum = 0
      lists.each do |list|
        @board.cards.each { |card| sum += card.estimate if list.id == card.id_list}
      end
      sum
    end
    
  end
  
end