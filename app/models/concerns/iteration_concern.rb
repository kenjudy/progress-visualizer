module IterationConcern
  attr_accessor :adapter, :user_profile

  def beginning_of_current_iteration
    @beginning_of_current_iteration ||= beginning_of_iteration(Time.zone.now)
  end

  def end_of_current_iteration
    @end_of_current_iteration ||= end_of_iteration(Time.zone.now)
  end

  def beginning_of_iteration(containing)
    start = sunday_start_of_week_for(containing) + user_profile.start_day_of_week + user_profile.start_hour.hours
    start - align_to_calendar(start)
  end

  def end_of_iteration(containing)
    (beginning_of_iteration(containing) + duration_adjusted_for_start_and_end_days).beginning_of_week(:sunday).to_datetime + user_profile.end_day_of_week + user_profile.end_hour.hours
  end

  def between_iterations(date)
    date = datetime_localtime(date)
    date < beginning_of_iteration(date) || date > end_of_iteration(date)
  end

  def prior_iteration(iteration)
    done_story = done_story_this_iteration(iteration)
    done_story.prior_iteration if done_story
  end

  def next_iteration(iteration)
    done_story = done_story_this_iteration(iteration)
    done_story.next_iteration if done_story
  end

  private
  
  def done_story_this_iteration(iteration)
    user_profile.done_story.find_by(iteration: iteration || beginning_of_current_iteration.to_date)
  end
  
  def sunday_start_of_week_for(date)
    #if iteration contain
    sunday = datetime_localtime(date).beginning_of_week(:sunday).to_datetime
    sunday -= 7.days if sunday.to_date == date.to_date
    sunday
  end

  def adjacent_iteration(comparitor, iteration)
    results = user_profile.done_stories.where("iteration #{comparitor} ?", iteration).order(iteration: comparitor == "<" ? :desc : :asc).limit(1)
    results.any? ? results.first.iteration : nil
  end

  def align_to_calendar(date)
    user_profile.duration > 7 && user_profile.start_date ? (date.to_date - user_profile.start_date).to_i % user_profile.duration : 0
  end

  def duration_adjusted_for_start_and_end_days
    (user_profile.duration - (user_profile.end_day_of_week - user_profile.start_day_of_week)).days
  end

  def datetime_localtime(date)
    datetime =  date.instance_of?(Date) ? Time.local(date.year, date.month, date.day) : date
    (datetime.utc? ? Time.zone.utc_to_local(datetime) : datetime)
  end
end