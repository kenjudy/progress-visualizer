class AddIndexToUserProfile < ActiveRecord::Migration
  def up
    add_index :user_profiles, :user_id
  end
  def down
    remove_index :user_profiles, :user_id
  end
end
