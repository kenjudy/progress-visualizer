class AdminController < ApplicationController
  include UserProfileConcern
  include ChartsConcern

  before_filter :authenticate_user!, :assign_user_profile, :admin_role
  
  def users
    @user_stats = UserProfile.find_by_sql("select users.id, users.created_at, last_sign_in_at, provider, count(user_profiles.id) as user_profiles from users left outer join user_profiles on (users.id = user_profiles.user_id) group by users.id, users.created_at, last_sign_in_at, provider order by last_sign_in_at desc")
    @user_chart = user_chart_visualization(@user_stats)
  end
  
  private
  
  def admin_role
    render :json => {'error' => 'authentication error'}, :status => 403 unless current_user.role == User::ROLES[:admin]
  end
  
  def user_chart_visualization(user_stats)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date', 'date' )
    data_table.new_column('number', "created")
    data_table.new_column('number', "last signed in")
    data = {}
    user_stats.each do |stat|
      add_date_row(data, stat.created_at.to_date, 0)
      add_date_row(data, stat.last_sign_in_at.to_date, 1) if stat.last_sign_in_at
    end
    rows = data.keys.sort.map{ |date| [date] + data[date] }

    # Add Rows and Values
    data_table.add_rows(rows)
    GoogleVisualr::Interactive::AreaChart.new(data_table, default_properties.merge({ title: "User Stats" }))
  end
  
  def add_date_row(data, date, column)
    data[date] ||= [0,0]
    data[date][column] += 1
  end
end
