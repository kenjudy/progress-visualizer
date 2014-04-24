module ChartsConcern
  extend ActiveSupport::Concern

  def default_properties
    blue = "#091D58"
    green = "#095857"
    red = "#af0303"
    orange = "#fd5b1c"

    { colors: [green, blue, red, orange, green, blue, red, orange],
      pointSize: 8,
      areaOpacity: 0.05,
      titleTextStyle: {color: green, fontSize: 24, fontName: 'Questrial', bold: false },
      chartArea: {width: '90%', height: '80%'},
      hAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"}, format:'MMM d, y' },
      vAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"} },
      legend: {position: 'bottom', alignment: 'center'}
    }
  end
  
  def yesterdays_weather_action(user_profile, range, iteration = nil)
    estimate_chart = YesterdaysWeatherChart.new(user_profile, {weeks: range, label: :estimate})
    @yesterdays_weather_estimate_chart = yesterdays_weather_visualization(user_profile, estimate_chart, iteration)
    @uses_estimates = has_non_zero_values(@yesterdays_weather_estimate_chart)

    stories_chart = YesterdaysWeatherChart.new(user_profile, {weeks: range, label: :stories})
    @yesterdays_weather_stories_chart = yesterdays_weather_visualization(user_profile, stories_chart, iteration)
  end

  def long_term_trend_action(user_profile, range, iteration = nil)
    @long_term_trend_chart = long_term_trend_visualization(user_profile, range, iteration)
  end

  private

  def burn_up_chart_visualization(options)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('datetime', 'Timestamp' )
    data_table.new_column('number', "Backlog by #{options[:label]}")
    data_table.new_column('number', "Complete by #{options[:label]}")

    # Add Rows and Values
    data_table.add_rows(burn_up_rows(options[:data]))
    GoogleVisualr::Interactive::AreaChart.new(data_table, default_properties.merge({ title: "Burn Up for #{options[:label]} #{date_label(data_table)}",
                                                                                     lineWidth: 6,
                                                                                     trendlines: { 1 => {pointSize: 0} }}))
  end

  def date_label(data_table)
    "#{data_table.rows.first[0].v.strftime("%B %e, %Y")} - #{data_table.rows.last[0].v.strftime("%B %e, %Y")}" if data_table.rows.any?
  end

  def yesterdays_weather_visualization(user_profile, chart, iteration = nil)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'timestamp' )
    if chart.types_of_work && chart.types_of_work.any?
      chart.types_of_work.each { |type_of_work| data_table.new_column('number', type_of_work.downcase ) }
    else
      data_table.new_column('number', "Cards" )
    end
    data_table.add_rows(yesterdays_weather_data_rows(user_profile, chart, iteration))
    GoogleVisualr::Interactive::ColumnChart.new(data_table, default_properties.merge({ title: "Yesterday's Weather for #{chart.label.to_s.titleize.pluralize}",
                                                                                       isStacked: true }))

  end

  def long_term_trend_visualization(user_profile, weeks, iteration = nil)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date', 'timestamp' )
    data_table.new_column('number', "estimates")
    data_table.new_column('number', "stories")

    # Add Rows and Values
    data_table.add_rows(long_term_trend_visualization_rows(user_profile, weeks, iteration))
    GoogleVisualr::Interactive::AreaChart.new(data_table, default_properties.merge({ title: "Long Term Trend",
                                                                                     hAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"}, format:'M/d' },
                                                                                     lineWidth: 2,
                                                                                     trendlines: { 1 => {pointSize: 0}, 0 => {pointSize: 0} }}))
  end

  def burn_up_rows(data)
    data.map{ |burn_up| [burn_up[:timestamp].getlocal, burn_up[:backlog], burn_up[:done]] }
  end

  def has_non_zero_values(chart)
    s=0
    chart.data_table.rows.each { |cols| cols[1..-1].each { |col| s += col.v  }}
    return s > 0
  end

  def long_term_trend_visualization_rows(user_profile, weeks, iteration = nil)
    data = {}
    done_stories_data(user_profile, weeks, iteration).each do |done_story|
      timestamp = done_story.timestamp
      data[timestamp] ||= [timestamp, 0, 0]
      data[timestamp][1] += done_story.estimate
      data[timestamp][2] += 1
    end
    data.values.sort { |a,b| a[0] <=> b[0] }
  end

  def yesterdays_weather_data_rows(user_profile, chart, iteration = nil)
    data = {}
    done_stories_data(user_profile, chart.weeks, iteration).each do |done_story|
      stack_by_types_of_work(chart, data, done_story)
    end
    data.values.sort { |a,b| a[0] <=> b[0] }
  end

  def done_stories_data(user_profile, range, iteration = nil)
    date =
    if iteration.instance_of?(String)
      query = 'timestamp > ? and timestamp <= ?'
      user_profile.beginning_of_iteration(Date.parse(iteration))
    elsif iteration.nil?
      query = 'timestamp >= ? and timestamp < ?'
      user_profile.beginning_of_current_iteration
    else
      query = 'timestamp > ? and timestamp <= ?'
      user_profile.beginning_of_iteration(iteration)
    end
    user_profile.done_stories.order("timestamp").where(query, date - (range * user_profile.duration).days, date).to_a
  end
  
  private
  
  def stack_by_types_of_work(chart, data, done_story)
    timestamp = done_story.timestamp.to_s
    value = chart.label == :estimate ? done_story.estimate : 1
    if chart.types_of_work && chart.types_of_work.any?
      data[timestamp] = data[timestamp] ||= [timestamp] + chart.types_of_work.length.times.map { 0 }
      chart.types_of_work.each_with_index { |type_of_work, index| data[timestamp][index+1] += done_story.type_of_work.downcase == type_of_work.downcase ? value : 0 }
    else
      data[timestamp] = data[timestamp] ||= [timestamp, 0]
      data[timestamp][1] += value
    end
  end
end
