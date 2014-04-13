module IterationConcern

  def beginning_of_current_iteration
    @beginning_of_current_iteration ||= beginning_of_iteration(Time.zone.now)
  end

  def end_of_current_iteration
    @end_of_current_iteration ||= end_of_iteration(Time.zone.now)
  end

  def beginning_of_iteration(containing)
    start = sunday_start_of_week_for(containing) + start_day_of_week + start_hour.hours
    start - align_to_calendar(start)
  end

  def end_of_iteration(containing)
    (beginning_of_iteration(containing) + duration_adjusted_for_start_and_end_days).beginning_of_week(:sunday).to_datetime + end_day_of_week + end_hour.hours
  end

  def between_iterations(date)
    date = datetime_localtime(date)
    date < beginning_of_iteration(date) || date > end_of_iteration(date)
  end

  def prior_iteration(iteration)
    done_story = done_story_this_iteration(iteration)
    (done_story.prior_iteration if done_story) || (done_stories.last.iteration if done_stories.any?)
  end

  def next_iteration(iteration)
    done_story = done_story_this_iteration(iteration)
    done_story.next_iteration if done_story
  end

  private
  
  def done_story_this_iteration(iteration)
    done_stories.find_by(iteration: iteration || beginning_of_current_iteration.to_date)
  end
  
  def sunday_start_of_week_for(date)
    #if iteration contain
    sunday = datetime_localtime(date).beginning_of_week(:sunday).to_datetime
    sunday -= 7.days if sunday.to_date == date.to_date
    sunday
  end

  def adjacent_iteration(comparitor, iteration)
    results = done_stories.where("iteration #{comparitor} ?", iteration).order(iteration: comparitor == "<" ? :desc : :asc).limit(1)
    results.any? ? results.first.iteration : nil
  end

  def align_to_calendar(date)
    duration > 7 && start_date ? (date.to_date - start_date).to_i % duration : 0
  end

  def duration_adjusted_for_start_and_end_days
    (duration - (end_day_of_week - start_day_of_week)).days
  end

  def datetime_localtime(date)
    datetime =  date.instance_of?(Date) ? Time.local(date.year, date.month, date.day) : date
    (datetime.utc? ? Time.zone.utc_to_local(datetime) : datetime)
  end
end