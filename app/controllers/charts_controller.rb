
class ChartsController < ApplicationController
  
  def daily_burnup
    data = Charts::DailyBurnup.current_burnup
    
    estimates_table = GoogleVisualr::DataTable.new
    estimates_table.new_column('datetime', 'Timestamp' )
    estimates_table.new_column('number', 'Backlog Estimates')
    estimates_table.new_column('number', 'Done Estimates')
    
    GoogleVisualr::DateFormat.new( { :formatType => 'short'  } )
    
    # Add Rows and Values
    estimates_table.add_rows(data.map{ |burnup| [burnup.timestamp, burnup.backlog_estimates, burnup.done_estimates] })
    
    @estimates_chart = GoogleVisualr::Interactive::LineChart.new(estimates_table, { height: 600, title: 'Daily Burnup Estimates', legend: 'top',  trendlines: { 1 => {} }})

    stories_table = GoogleVisualr::DataTable.new
    stories_table.new_column('datetime', 'Timestamp' )
    stories_table.new_column('number', 'Backlog Stories')
    stories_table.new_column('number', 'Done Stories')
    
    # Add Rows and Values
    stories_table.add_rows(data.map{ |burnup| [burnup.timestamp, burnup.backlog, burnup.done] })
    
    @stories_chart = GoogleVisualr::Interactive::LineChart.new(stories_table, { height: 600, title: 'Daily Burnup Story Count', legend: 'top',  trendlines: { 1 => {} } })
  end
  
end
