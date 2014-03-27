class AddDefaultsToUserProfiles < ActiveRecord::Migration
  def up
    change_column :user_profiles, :start_day_of_week, :integer, default: 1
    change_column :user_profiles, :start_hour,        :integer, default: 0
    change_column :user_profiles, :end_day_of_week,   :integer, default: 6
    change_column :user_profiles, :end_hour,          :integer, default: 0
  end

  def down
    change_column :user_profiles, :start_day_of_week, :integer, default: nil
    change_column :user_profiles, :start_hour,        :integer, default: nil
    change_column :user_profiles, :end_day_of_week,   :integer, default: nil
    change_column :user_profiles, :end_hour,          :integer, default: nil
  end
end
