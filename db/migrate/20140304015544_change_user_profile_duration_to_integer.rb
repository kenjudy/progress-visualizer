class ChangeUserProfileDurationToInteger < ActiveRecord::Migration
  def self.up
    UserProfile.connection.execute("update user_profiles set duration='7'")
    change_column :user_profiles, :duration,  'integer using cast(duration as integer)'
   end

  def self.down
    change_column :user_profiles, :duration,  'varchar using cast(duration as varchar)'
    UserProfile.connection.execute("update user_profiles set duration='WEEKLY'")
  end
end
