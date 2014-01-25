module Visualizations
  
  def default_adapter
    Adapters::TrelloAdapter
  end
  
  def end_of_current_iteration
    Date.today.end_of_week
  end
  
  def beginning_of_current_iteration
    Date.today.end_of_week - 6.days
  end
end