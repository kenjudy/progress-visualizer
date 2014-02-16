module Charts
  class BurnUpChart
    extend ActiveSupport::Concern
    extend ::IterationConcern
    include ::IterationConcern
    
    attr_accessor :done_lists, :backlog_lists, :timestamp

    def initialize(user_profile)
      @user_profile = user_profile
      request_data
    end
        
    def update
      done_stats = stats(@done_lists.keys)
      backlog_stats = stats(@backlog_lists.keys)
      unless redundant?(done_stats, backlog_stats)
        BurnUp.create(user_profile: @user_profile,timestamp: timestamp, done: done_stats[:count], done_estimates: done_stats[:sum], backlog: backlog_stats[:count], backlog_estimates: backlog_stats[:sum] )
      end
    end
    
    def redundant?(done_stats, backlog_stats)
      last_burnup = BurnUp.last
      last_burnup && 
      last_burnup.timestamp > Time.now - 2.hours && 
      last_burnup.done == done_stats[:count] && 
      last_burnup.done_estimates == done_stats[:sum] && 
      last_burnup.backlog == backlog_stats[:count] && 
      last_burnup.backlog_estimates == backlog_stats[:sum]
    end
    
    def self.current(user_profile)
      Charts::BurnUpChart.new(user_profile)
    end
    
    def self.current_burn_up_data(user_profile)
      user_profile.burn_ups.where("timestamp > ? and timestamp <= ?", beginning_of_current_iteration, end_of_current_iteration)
    end
    
    private
    
    def request_data
       @board = adapter.request_board(adapter.current_sprint_board_properties[:id])
       @timestamp = Time.now
       @done_lists = adapter.current_sprint_board_properties[:done_lists]
       @backlog_lists =  adapter.current_sprint_board_properties[:backlog_lists]
     end
    
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