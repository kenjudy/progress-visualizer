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
  
  def yesterdays_weather_action(user_or_profile, range, iteration = nil)
    case user_or_profile.class.name
    when 'UserProfile'
      user_profiles = [user_or_profile]
    when 'User'
      user_profiles = user_or_profile.user_profiles
    else
      user_profiles = []
    end
    estimate_chart = YesterdaysWeatherChart.new(user_profiles, {weeks: range, label: :estimate})
    @yesterdays_weather_estimate_chart = yesterdays_weather_visualization(user_profiles, estimate_chart, iteration)
    @uses_estimates = has_non_zero_values(@yesterdays_weather_estimate_chart)

    stories_chart = YesterdaysWeatherChart.new(user_profiles, {weeks: range, label: :stories})
    @yesterdays_weather_stories_chart = yesterdays_weather_visualization(user_profiles, stories_chart, iteration)
  end

  def long_term_trend_action(user_profile, range, iteration = nil)
    rows = long_term_trend_visualization_rows(done_stories_data([user_profile], range, iteration))
    @long_term_trend_chart = long_term_trend_visualization(rows)
    @stats = long_term_trend_stats(rows)
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

  def yesterdays_weather_visualization(user_profiles, chart, iteration = nil)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'timestamp' )
    if chart.types_of_work && chart.types_of_work.any?
      chart.types_of_work.each { |type_of_work| data_table.new_column('number', type_of_work ? type_of_work.downcase : 'unlabeled' ) }
    else
      data_table.new_column('number', "Cards" )
    end
    data_table.add_rows(yesterdays_weather_data_rows(user_profiles, chart, iteration))
    GoogleVisualr::Interactive::ColumnChart.new(data_table, default_properties.merge({ title: "Yesterday's Weather for #{chart.label.to_s.titleize.pluralize}#{board_label('in', user_profiles)}",
                                                                                       isStacked: true }))

  end

  def long_term_trend_visualization(rows)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date', 'timestamp' )
    data_table.new_column('number', "estimates")
    data_table.new_column('number', "stories")

    # Add Rows and Values
    data_table.add_rows(rows)
    GoogleVisualr::Interactive::AreaChart.new(data_table, default_properties.merge({ title: "Long Term Trend#{board_label('for')}",
                                                                                     hAxis: { textStyle: { color: '#999999'}, gridLines: { color: "#eee"}, format:'M/d' },
                                                                                     lineWidth: 2,
                                                                                     trendlines: { 1 => {pointSize: 0}, 0 => {pointSize: 0} }}))
  end
  
  def long_term_trend_stats(rows)
    points = rows.map { |row| row[1] }
    stories = rows.map { |row| row[2] }
    { stories: { average: average(stories), median: median(stories) }, points: { average: average(points), median: median(points) } }
  end
  
  def burn_up_rows(data)
    data.map{ |burn_up| [burn_up[:timestamp].getlocal, burn_up[:backlog], burn_up[:done]] }
  end

  def has_non_zero_values(chart)
    s=0
    chart.data_table.rows.each { |cols| cols[1..-1].each { |col| s += col.v  }}
    return s > 0
  end

  def long_term_trend_visualization_rows(data)
    rows = {}
    data.each do |done_story|
      timestamp = done_story.timestamp
      rows[timestamp] ||= [timestamp, 0, 0]
      rows[timestamp][1] += done_story.estimate
      rows[timestamp][2] += 1
    end
    rows.values.sort { |a,b| a[0] <=> b[0] }
  end

  def yesterdays_weather_data_rows(user_profiles, chart, iteration = nil)
    data = {}
    done_stories_data(user_profiles, chart.weeks, iteration).each do |done_story|
      stack_by_types_of_work(chart, data, done_story)
    end
    data.values.sort { |a,b| a[0] <=> b[0] }
  end

  def done_stories_data(user_profiles, range, iteration = nil)
    if iteration.instance_of?(String)
      query = 'timestamp > ? and timestamp <= ? and user_profile_id in (?)'
      boi_arg = Date.parse(iteration)
    elsif iteration.nil?
      query = 'timestamp >= ? and timestamp < ? and user_profile_id in (?)'
      boi_arg = nil
    else
      query = 'timestamp > ? and timestamp <= ? and user_profile_id in (?)'
      boi_arg = iteration
    end
    date = user_profiles.map{ |p| boi_arg ? p.beginning_of_iteration(boi_arg) : p.beginning_of_current_iteration }.sort.first
    DoneStory.where(query, date - (range * user_profiles.first.duration).days, date, user_profiles.map(&:id)).order("timestamp").to_a
  end
  
  private
  
  def median(arr)
    return 0 unless arr.any?
    sorted = arr.sort
    len = sorted.length
    return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end
  
  def average(arr)
    return 0 unless arr.any?
    arr.inject(0.0) { |sum, el| sum + el } / arr.size
  end

  def stack_by_types_of_work(chart, data, done_story)
    timestamp = done_story.timestamp.to_s
    value = chart.label == :estimate ? done_story.estimate : 1
    if chart.types_of_work && chart.types_of_work.any?
      data[timestamp] = data[timestamp] ||= [timestamp] + chart.types_of_work.length.times.map { 0 }
      chart.types_of_work.each_with_index { |type_of_work, index| data[timestamp][index+1] += increment?(done_story, type_of_work) ? value : 0 }
    else
      data[timestamp] = data[timestamp] ||= [timestamp, 0]
      data[timestamp][1] += value
    end
  end
  
  def increment?(done_story, type_of_work)
    (done_story.type_of_work.nil? && type_of_work.nil?) || 
    (done_story.type_of_work  && type_of_work && done_story.type_of_work.downcase == type_of_work.downcase)
  end
end
