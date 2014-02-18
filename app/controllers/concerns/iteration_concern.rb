module IterationConcern
  extend UserProfileConcern
  
  attr_accessor :adapter
  
  def beginning_of_current_iteration
    @beginning_of_current_iteration ||= current_iteration_setup[0]
  end
       
  def end_of_current_iteration
    @end_of_current_iteration ||= current_iteration_setup[1]
  end
  
  def beginning_of_iteration(containing)
    iteration_setup(containing)[0]
  end
  
  def end_of_iteration(containing)
    iteration_setup(containing)[1]
  end
  
  private
  
  def current_iteration_setup
    results = iteration_setup(Date.today)
    @beginning_of_current_iteration = results[0]
    @end_of_current_iteration = results[1]
    return results
  end
  
  def iteration_setup(containing)
    raise StandardError.new("TODO: Only WEEKLY Supported") if user_profile.duration != "WEEKLY"

    end_day_of_week = user_profile.end_day_of_week ||= 6
    start_day_of_week = user_profile.start_day_of_week ||= 1

    end_day_of_week = end_day_of_week + 8 if end_day_of_week <= start_day_of_week 
    end_hour = user_profile.end_hour ||= 0
    start_hour = user_profile.start_hour ||= 0

    end_of_current_iteration = Time.zone.local_to_utc(containing.end_of_week.to_datetime - (7 - end_day_of_week).days +  end_hour.hours)
    beginning_of_current_iteration = Time.zone.local_to_utc(containing.end_of_week.to_datetime - (7 - start_day_of_week).days +  start_hour.hours)
    
    [beginning_of_current_iteration, end_of_current_iteration]
  end    
  
end