class ChangeStringsInUserProfileToText < ActiveRecord::Migration
  def up
    change_column :user_profiles, :encrypted_backlog_lists, :text
    change_column :user_profiles, :encrypted_done_lists, :text
    change_column :user_profiles, :labels_types_of_work, :text
  end
  def down
    change_column :user_profiles, :encrypted_backlog_lists, :string
    change_column :user_profiles, :encrypted_done_lists, :string
    change_column :user_profiles, :labels_types_of_work, :string
  end
end
