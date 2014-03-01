class ChangeIndexStoryIdUserProfileInDoneStories < ActiveRecord::Migration
  def change
    remove_index :done_stories, :story_id
    add_index :done_stories, [:user_profile_id, :story_id], unique: true
  end
end
