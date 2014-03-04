module IterationConcern
  extend UserProfileConcern
  
  attr_accessor :adapter
  
  def beginning_of_current_iteration
    @beginning_of_current_iteration ||= beginning_of_iteration(Date.today)
  end
       
  def end_of_current_iteration
    @end_of_current_iteration ||= end_of_iteration(Date.today)
  end
  
  def beginning_of_iteration(containing)
    Time.zone.local_to_utc(beginning_of_iteration_in_localtime(containing))
  end
  
  def end_of_iteration(containing)
    Time.zone.local_to_utc(end_of_iteration_in_localtime(containing))
  end
  
  private
  
  def beginning_of_iteration_in_localtime(containing)
    containing.end_of_week.to_datetime - (7 - user_profile.start_day_of_week).days +  user_profile.start_hour.hours
  end
  
  def end_of_iteration_in_localtime(containing)
    beginning_of_iteration_in_localtime(containing).to_date + iteration_days(user_profile) + user_profile.end_hour.hours
  end  
    
  def iteration_days(user_profile)
    day_offset = user_profile.end_day_of_week > user_profile.start_day_of_week ? user_profile.start_day_of_week + 7 : 1
    user_profile.end_day_of_week + user_profile.duration - day_offset
  end
  
end