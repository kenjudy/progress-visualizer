module BaseVisualization
  attr_accessor :adapter
  
  def adapter
    @adapter || Constants::CONFIG[:default_adapter]
  end
  
  def end_of_current_iteration
    Constants::CONFIG[:iteration_end]
  end
  
  def beginning_of_current_iteration
    Constants::CONFIG[:iteration_start]
  end
  
  def beginning_of_prior_iteration
    Constants::CONFIG[:iteration_start] - (Constants::CONFIG[:iteration_end] - Constants::CONFIG[:iteration_start] - 1)
  end
end