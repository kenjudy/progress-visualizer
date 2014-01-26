module ChartVisualizations
  extend ActiveSupport::Concern
  
  @@green = "#3D7477"
  @@blue = "#091D58"
  @@red = "#991238"

  def burnup_chart_visualization(options)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('datetime', 'Timestamp' )
    data_table.new_column('number', "Backlog by #{options[:label]}")
    data_table.new_column('number', "Complete by #{options[:label]}")
  
    #GoogleVisualr::DateFormat.new( { :formatType => 'short'  } )
  
    # Add Rows and Values
    data_table.add_rows(options[:data].map{ |burnup| [burnup[:timestamp], burnup[:backlog], burnup[:done]] })
  
    GoogleVisualr::Interactive::AreaChart.new(data_table, { title: "Daily Burnup #{options[:label]}",
                                                            colors: [@@blue,@@green],
                                                            areaOpacity: 0.05, 
                                                            titleTextStyle: {color: @@green, fontSize: 24 },
                                                            hAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"} },
                                                            vAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"} },
                                                            legend: {position: 'bottom', alignment: 'center'},  
                                                            lineWidth: 6, 
                                                            trendlines: { 1 => {} }})
  end
  
  def yesterdays_weather_visualization(options)
    label = options[:label] || :estimate
    weeks = options[:weeks] || 3
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'timestamp' )
    data_table.new_column('number', 'committed' )
    data_table.new_column('number', 'contingent' )
    data_table.new_column('number', 'inserted' )
    
    data_table.add_rows(yesterdays_weather_data_rows(label, weeks))
    GoogleVisualr::Interactive::ColumnChart.new(data_table, { title: "Yesterday's Weather for #{label.to_s.titleize.pluralize}",
                                                              colors: [@@blue, @@green, @@red],
                                                              titleTextStyle: {color: '#333333', fontSize: 24 },
                                                              areaOpacity: 0.05, 
                                                              legend: {position: 'bottom', alignment: 'center'},  
                                                             isStacked: true
                                                            })
  
  end
  
  def long_term_trend_visualization(weeks = 10)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date', 'timestamp' )
    data_table.new_column('number', "estimates")
    data_table.new_column('number', "stories")
    
    # Add Rows and Values
    data_table.add_rows(long_term_trend_visualization_rows(weeks))
  
    GoogleVisualr::Interactive::AreaChart.new(data_table, { title: "Long Term Trend",
                                                            colors: [@@blue,@@green],
                                                            areaOpacity: 0.05, 
                                                            titleTextStyle: {color: @@green, fontSize: 24 },
                                                            hAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"} },
                                                            vAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"} },
                                                            legend: {position: 'bottom', alignment: 'center'},  
                                                            lineWidth: 2, 
                                                            trendlines: { 1 => {}, 0 => {} }
                                                          })
  end

  def long_term_trend_visualization_rows(weeks = 10)
    DoneStory.select_yesterdays_weather(weeks).values.map do |stat|
      [stat[:timestamp], 
        stat[:effort]["Committed"] ? stat[:effort]["Committed"][:estimate] : 0 +
        stat[:effort]["Contingent"] ? stat[:effort]["Contingent"][:estimate] : 0 +
        stat[:effort]["Inserted"] ? stat[:effort]["Inserted"][:estimate] : 0,
        stat[:effort]["Committed"] ? stat[:effort]["Committed"][:stories] : 0 +
        stat[:effort]["Contingent"] ? stat[:effort]["Contingent"][:stories] : 0 +
        stat[:effort]["Inserted"] ? stat[:effort]["Inserted"][:stories] : 0,
      ]
    end
  end
  
  def yesterdays_weather_data_rows(label, weeks)
    DoneStory.select_yesterdays_weather(weeks).values.map do |stat|
      [stat[:timestamp].to_s, 
        stat[:effort]["Committed"] ? stat[:effort]["Committed"][label] : 0, 
        stat[:effort]["Contingent"] ? stat[:effort]["Contingent"][label] : 0, 
        stat[:effort]["Inserted"] ? stat[:effort]["Inserted"][label] : 0 ]
    end
  end
end
