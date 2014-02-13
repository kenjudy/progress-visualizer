module IterationConcern
  attr_accessor :adapter
  
  @@adapter = Rails.application.config.adapter
  
  def adapter=(adapter)
    @@adapter = adapter
  end
  
  def adapter
    @@adapter 
  end
  
  def end_of_current_iteration
    Rails.application.config.iteration_end
  end
  
  def beginning_of_current_iteration
    Rails.application.config.iteration_start
  end
  
  def beginning_of_prior_iteration
    Rails.application.config.iteration_start - (Rails.application.config.iteration_end - Rails.application.config.iteration_start - 1)
  end
end