class ChangeUserProfileDurationToInteger < ActiveRecord::Migration
  def self.up
    say "replace durations with '7'" do
      UserProfile.connection.execute("update user_profiles set duration='7'")
    end
    say "change col from varchar to integer" do
      change_column :user_profiles, :duration,  'integer using cast(duration as integer)'
    end
   end

  def self.down
    say "change col from integer to varchar" do
      change_column :user_profiles, :duration,  'varchar using cast(duration as varchar)'
    end
    say "replace durations with 'WEEKLY'" do
      UserProfile.connection.execute("update user_profiles set duration='WEEKLY'")
    end
  end
end
