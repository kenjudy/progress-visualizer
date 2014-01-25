
class ChartsController < ApplicationController
  include ChartVisualizations
  
  def daily_burnup
    data = Charts::DailyBurnup.current_burnup_data
        
    @estimates_chart = burnup_chart_visualization({label: "Estimates", data:  data.map{ |burnup| { timestamp: burnup.timestamp, backlog: burnup.backlog_estimates, done: burnup.done_estimates} }})

    @stories_chart = burnup_chart_visualization({label: "Story Counts", data:  data.map{ |burnup| { timestamp: burnup.timestamp, backlog: burnup.backlog, done: burnup.done} }})
  end
  
end
