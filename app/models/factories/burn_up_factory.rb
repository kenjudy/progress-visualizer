class Factories::BurnUpFactory
  include IterationConcern

  attr_accessor :done_lists, :backlog_lists, :timestamp

  def initialize(user_profile)
    @user_profile = user_profile
    @timestamp = Time.now
    @done_lists = JSON.parse(@user_profile.done_lists)
    @backlog_lists =  JSON.parse(@user_profile.backlog_lists)
    @burn_up_data = {}
  end

  def update
    request_data
    done_stats = stats(@done_lists.keys)
    backlog_stats = stats(@backlog_lists.keys + @done_lists.keys)
    unless redundant?(done_stats, backlog_stats)
      BurnUp.create(user_profile: @user_profile, timestamp: timestamp, done: done_stats[:count], done_estimates: done_stats[:sum], backlog: backlog_stats[:count], backlog_estimates: backlog_stats[:sum] )
    end
  end

  def redundant?(done_stats, backlog_stats)
    last_burnup = @user_profile.burn_ups.last
    last_burnup &&
    last_burnup.timestamp > Time.now - 2.hours &&
    last_burnup.done == done_stats[:count] &&
    last_burnup.done_estimates == done_stats[:sum] &&
    last_burnup.backlog == backlog_stats[:count] &&
    last_burnup.backlog_estimates == backlog_stats[:sum]
  end

  def estimates_burn_up_data(containing = nil)
    burn_up_data(true, containing)
  end
  
  def stories_burn_up_data(containing = nil)
    burn_up_data(false, containing)
  end

  private
  
  def burn_up_data(for_estimates, containing = nil)
    suffix = for_estimates ? "_estimates" : ""
    data = 
      if @burn_up_data[containing]
        @burn_up_data[containing]
      elsif containing
        @burn_up_data[containing] = @user_profile.burn_ups.where("timestamp > ? and timestamp <= ?", beginning_of_iteration(containing), end_of_iteration(containing)).order(timestamp: :asc)
      else
        @burn_up_data[containing] =@user_profile.burn_ups.where("timestamp > ? and timestamp <= ?", beginning_of_current_iteration, end_of_current_iteration).order(timestamp: :asc)
      end
    data.map{ |burn_up| { timestamp: burn_up.timestamp, backlog: burn_up.send("backlog#{suffix}"), done: burn_up.send("done#{suffix}")} }
  end

  def request_data
     @board = BaseAdapter.build_adapter(@user_profile).request_board(@user_profile.current_sprint_board_id_short)
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