module Tables::DoneStoriesConcern
  extend ActiveSupport::Concern
  def prior_iteration(iteration)
    adjacent_iteration("<", iteration)
  end
  def next_iteration(iteration)
    adjacent_iteration(">", iteration)
  end

  def adjacent_iteration(comparitor, iteration)
    results = user_profile.done_stories.where("iteration #{comparitor} ?", iteration).order(iteration: comparitor == "<" ? :desc : :asc).limit(1)
    results.any? ? results.first.iteration : nil
  end
end