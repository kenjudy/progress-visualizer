class AdminController < ApplicationController
  include UserProfileConcern
  include ChartsConcern

  before_filter :authenticate_user!, :assign_user_profile, :admin_role
  
  def users
    @user_stats = UserProfile.find_by_sql("select users.id, users.created_at, last_sign_in_at, provider, count(user_profiles.id) as user_profiles from users left outer join user_profiles on (users.id = user_profiles.user_id) group by users.id, users.created_at, last_sign_in_at, provider order by last_sign_in_at desc")
    @user_chart = user_chart_visualization(@user_stats)
    @duration_stats = UserProfile.select("count(*), duration").distinct.group("duration")
  end
  
  def cards
    @webhooks_stats = Webhook.all.count
    @burn_up_stats = {total: BurnUp.all.count, with_estimates: BurnUp.where("backlog_estimates > 0").count}
    @done_story_stats = {total: DoneStory.all.count, with_estimates: DoneStory.where("estimate > 0").count}
    @burn_up_stat_chart = burn_up_visualization(BurnUp.select("cast(created_at as date) as created_date, count(backlog)").group("created_date").order("created_date"))
    @done_story_stat_chart = done_story_visualization(DoneStory.select("cast(created_at as date) as created_date, count(*)").group("created_date").order("created_date"),
                                                      DoneStory.select("cast(updated_at as date) as updated_date, count(*)").group("updated_date").order("updated_date"))
  end
  
  private
  
  def admin_role
    render :json => {'error' => 'authentication error'}, :status => 403 unless current_user.role == User::ROLES[:admin]
  end
  
  def user_chart_visualization(user_stats)
    data_table = data_table([['date', 'date'], ['number', "created"], ['number', "last signed in"]])
    data = {}
    user_stats.each do |stat|
      add_date_row(data, stat.created_at.to_date, 1, 0)
      add_date_row(data, stat.last_sign_in_at.to_date, 1, 1) if stat.last_sign_in_at
    end
    rows = data.keys.sort.map{ |date| [date] + data[date] }

    # Add Rows and Values
    data_table.add_rows(rows)
    GoogleVisualr::Interactive::AreaChart.new(data_table, default_properties.merge({ title: "User Stats" }))
  end
  
  def burn_up_visualization(burn_up_result)
    data_table = data_table([['date', 'created'],['number', "records created"]])
    data_table.add_rows(burn_up_result.map { |r| [r.created_date, r.count] })
    GoogleVisualr::Interactive::AreaChart.new(data_table, default_properties.merge({ title: "BurnUp Stats" }))
  end
  
  def done_story_visualization(created_stats, updated_stats)
    data_table = data_table([['date', 'date'], ['number', "records created"], ['number', "records updated"]])
    data = {}
    created_stats.each { |stat| add_date_row(data, stat.created_date, stat.count, 0) }
    updated_stats.each { |stat| add_date_row(data, stat.updated_date, stat.count, 1) }
    rows = data.keys.sort.map{ |date| [date] + data[date] }
    data_table.add_rows(rows)
    GoogleVisualr::Interactive::AreaChart.new(data_table, default_properties.merge({ title: "DoneStory Stats" }))
  end
  
  def data_table(columns)
    data_table = GoogleVisualr::DataTable.new
    columns.each { |col| data_table.new_column(col[0], col[1]) }
    data_table
  end
  
  def add_date_row(data, date, val, column)
    return unless date
    
    data[date] ||= [0,0]
    data[date][column] += val
  end
end
