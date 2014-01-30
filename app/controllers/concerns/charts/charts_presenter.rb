module Charts::ChartsPresenter
  extend ActiveSupport::Concern
  
  @@green = "#3D7477"
  @@blue = "#091D58"
  @@red = "#991238"
  
  @@default_properties = { colors: [@@blue,@@green, @@red],
                                    areaOpacity: 0.05, 
                                    titleTextStyle: {color: @@green, fontSize: 24 },
                                    hAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"}, format:'MMM d, y hh:mma' },
                                    vAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"} },
                                    legend: {position: 'bottom', alignment: 'center'}}

  def burn_up_chart_visualization(options)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('datetime', 'Timestamp' )
    data_table.new_column('number', "Backlog by #{options[:label]}")
    data_table.new_column('number', "Complete by #{options[:label]}")
  
    # Add Rows and Values
    data_table.add_rows(burn_up_rows(options[:data]))
  
    GoogleVisualr::Interactive::AreaChart.new(data_table, @@default_properties.merge({ title: "Burn Up Chart #{options[:label]}",
                                                                                        lineWidth: 6, 
                                                                                        trendlines: { 1 => {} }}))
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
    GoogleVisualr::Interactive::ColumnChart.new(data_table, @@default_properties.merge({ title: "Yesterday's Weather for #{label.to_s.titleize.pluralize}",
                                                                                         isStacked: true }))
  
  end
  
  def long_term_trend_visualization(weeks = 10)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date', 'timestamp' )
    data_table.new_column('number', "estimates")
    data_table.new_column('number', "stories")
    
    # Add Rows and Values
    data_table.add_rows(long_term_trend_visualization_rows(weeks))
  
    GoogleVisualr::Interactive::AreaChart.new(data_table, @@default_properties.merge({ title: "Long Term Trend",
                                                                                       hAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"}, format:'M/d' },
                                                                                       lineWidth: 2, 
                                                                                       trendlines: { 1 => {}, 0 => {} }}))
  end
  
  def burn_up_rows(data)
    data.map{ |burn_up| [burn_up[:timestamp], burn_up[:backlog], burn_up[:done]] }
  end

  def long_term_trend_visualization_rows(weeks = 10)
    DoneStory.select_done_stories(weeks).values.map do |stat|
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
    DoneStory.select_done_stories(weeks).values.map do |stat|
      [stat[:timestamp].to_s, 
        stat[:effort]["Committed"] ? stat[:effort]["Committed"][label] : 0, 
        stat[:effort]["Contingent"] ? stat[:effort]["Contingent"][label] : 0, 
        stat[:effort]["Inserted"] ? stat[:effort]["Inserted"][label] : 0 ]
    end
  end
end
