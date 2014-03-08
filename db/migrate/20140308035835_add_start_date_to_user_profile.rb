class AddStartDateToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :start_date, :date
  end
end
