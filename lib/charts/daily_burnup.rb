module Charts
  class DailyBurnup
    
    attr_accessor :done_list_ids, :backlog_list_ids, :timestamp

    def initialize(board, options = {})
      @board = board
      @timestamp = options[:timestamp] || Time.now
      @done_list_ids = options[:done_list_ids]
      @backlog_list_ids = options[:backlog_list_ids]
    end
    
    def update_progress
      done_stats = stats(@done_list_ids)
      backlog_stats = stats(@backlog_list_ids)
      BurnUp.create(timestamp: timestamp, done: done_stats[:count], done_estimates: done_stats[:sum], backlog: backlog_stats[:count], backlog_estimates: backlog_stats[:sum] )
    end
    
    def self.current_burnup(adapter)
      board = adapter.request_board(adapter.current_sprint_board_properties[:id])
      Charts::DailyBurnup.new(board, { done_list_ids: adapter.current_sprint_board_properties[:done_list_ids],
                                       backlog_list_ids: adapter.current_sprint_board_properties[:backlog_list_ids],
                                       timestamp: Time.now})
    end
    
    
    def self.current_burnup_data
      end_of_week = Date.today.end_of_week
      burnup_data(end_of_week - 7.days, end_of_week)
    end
    
    def self.burnup_data(start_datetime, end_datetime)
      BurnUp.where("timestamp > ? and timestamp <= ?", start_datetime, end_datetime)
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