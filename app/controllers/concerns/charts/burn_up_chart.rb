module Charts
  class BurnUpChart
    extend ActiveSupport::Concern
    extend ::BaseVisualization
    
    attr_accessor :done_list_ids, :backlog_list_ids, :timestamp

    def initialize(board, options = {})
      @board = board
      @timestamp = options[:timestamp] || Time.now
      @done_list_ids = options[:done_list_ids]
      @backlog_list_ids = options[:backlog_list_ids]
    end
    
    def update
      done_stats = stats(@done_list_ids)
      backlog_stats = stats(@backlog_list_ids)
      unless redundant?(done_stats, backlog_stats)
        BurnUp.create(timestamp: timestamp, done: done_stats[:count], done_estimates: done_stats[:sum], backlog: backlog_stats[:count], backlog_estimates: backlog_stats[:sum] )
      end
    end
    
    def redundant?(done_stats, backlog_stats)
      last_burnup = BurnUp.last
      last_burnup && 
      last_burnup.timestamp > Time.now - 6.hours && 
      last_burnup.done == done_stats[:count] && 
      last_burnup.done_estimates == done_stats[:sum] && 
      last_burnup.backlog == backlog_stats[:count] && 
      last_burnup.backlog_estimates == backlog_stats[:sum]
    end
    
    def self.current(adapter = default_adapter)
      board = adapter.request_board(adapter.current_sprint_board_properties[:id])
      Charts::BurnUpChart.new(board, { done_list_ids: adapter.current_sprint_board_properties[:done_list_ids],
                                       backlog_list_ids: adapter.current_sprint_board_properties[:backlog_list_ids],
                                       timestamp: Time.now})
    end
    
    def self.current_burn_up_data
      BurnUp.burn_up_data(beginning_of_current_iteration, end_of_current_iteration)
    end
    
    private
    
    def stats(list_ids)
      sum = 0
      count = 0
      list_ids.each do |list_id|
        @board.cards.each do |card|
          if list_id == card.id_list
            sum += card.estimate
            count += 1
          end
        end
      end
      {sum: sum, count: count}
    end
    
  end
  
end