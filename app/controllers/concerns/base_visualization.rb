module BaseVisualization
  
  def default_adapter
    Adapters::TrelloAdapter
  end
  
  def end_of_current_iteration
    Constants::ITERATION[:iteration_end]
  end
  
  def beginning_of_current_iteration
    Constants::ITERATION[:iteration_start]
  end
  
  def beginning_of_prior_iteration
    Constants::ITERATION[:iteration_start] - (Constants::ITERATION[:iteration_end] - Constants::ITERATION[:iteration_start] - 1)
  end
end