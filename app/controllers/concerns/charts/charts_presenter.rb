module Charts::ChartsPresenter
  extend ActiveSupport::Concern
  
  @@green = "#3D7477"
  @@blue = "#091D58"
  @@red = "#991238"
  
  @@default_properties = { colors: [@@blue,@@green, @@red],
                                    areaOpacity: 0.05, 
                                    titleTextStyle: {color: @@green, fontSize: 24 },
                                    chartArea: {width: '90%', height: '80%'},
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
  
  def yesterdays_weather_visualization(chart, include_current = false)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'timestamp' )
    chart.types_of_work.each { |type_of_work| data_table.new_column('number', type_of_work.downcase ) }
    
    data_table.add_rows(yesterdays_weather_data_rows(chart.label, chart.weeks, chart.types_of_work, include_current))
    GoogleVisualr::Interactive::ColumnChart.new(data_table, @@default_properties.merge({ title: "Yesterday's Weather for #{chart.label.to_s.titleize.pluralize}",
                                                                                         isStacked: true }))
  
  end
  
  def long_term_trend_visualization(weeks, include_current = false)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date', 'timestamp' )
    data_table.new_column('number', "estimates")
    data_table.new_column('number', "stories")
    
    # Add Rows and Values
    data_table.add_rows(long_term_trend_visualization_rows(weeks, include_current))
  
    GoogleVisualr::Interactive::AreaChart.new(data_table, @@default_properties.merge({ title: "Long Term Trend",
                                                                                       hAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"}, format:'M/d' },
                                                                                       lineWidth: 2, 
                                                                                       trendlines: { 1 => {}, 0 => {} }}))
  end
  
  def burn_up_rows(data)
    data.map{ |burn_up| [burn_up[:timestamp].getlocal, burn_up[:backlog], burn_up[:done]] }
  end

  def long_term_trend_visualization_rows(weeks, include_current = false)
    data = {}
    done_stories_data(weeks, include_current).each do |done_story|
      timestamp = done_story.timestamp
      data[timestamp] ||= [timestamp, 0, 0]
      data[timestamp][1] += done_story.estimate
      data[timestamp][2] += 1
    end
    data.values.sort { |a,b| a[0] <=> b[0] }
  end
  
  def yesterdays_weather_data_rows(label, weeks, types_of_work, include_current = false)
    data = {}
    done_stories_data(weeks, include_current).each do |done_story|
      timestamp = done_story.timestamp.to_s
      data[timestamp] = data[timestamp] ||= [timestamp, 0, 0, 0]

      value = label == :estimate ? done_story.estimate : 1
      types_of_work.each_with_index { |type_of_work, index| data[timestamp][index+1] += done_story.type_of_work.downcase == type_of_work.downcase ? value : 0 }
    end
    data.values.sort { |a,b| a[0] <=> b[0] }
  end
  
  def done_stories_data(range, include_current = false)
    offset = include_current ? 0 : 1.week
    user_profile.done_stories.order("timestamp").where('timestamp > ? and timestamp <= ?', Rails.application.config.iteration_start - range.weeks - offset, Rails.application.config.iteration_end - offset).to_a
  end
end
