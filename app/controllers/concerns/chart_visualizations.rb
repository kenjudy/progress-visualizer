module ChartVisualizations
  extend ActiveSupport::Concern

  def burnup_chart_visualization(options)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('datetime', 'Timestamp' )
    data_table.new_column('number', "Backlog by #{options[:label]}")
    data_table.new_column('number', "Complete by #{options[:label]}")
  
    #GoogleVisualr::DateFormat.new( { :formatType => 'short'  } )
  
    # Add Rows and Values
    data_table.add_rows(options[:data].map{ |burnup| [burnup[:timestamp], burnup[:backlog], burnup[:done]] })
  
    GoogleVisualr::Interactive::AreaChart.new(data_table, { title: "Daily Burnup #{options[:label]}",
                                                            colors: ['#0000CC','#339933'],
                                                            areaOpacity: 0.05, 
                                                            titleTextStyle: {color: '#333333', fontSize: 24 },
                                                            hAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"} },
                                                            vAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"} },
                                                            legend: {position: 'bottom', alignment: 'center'},  
                                                            lineWidth: 6, 
                                                            trendlines: { 1 => {} }})
  end
end
