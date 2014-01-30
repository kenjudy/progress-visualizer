class AddIndexToDoneStories < ActiveRecord::Migration
  def change
    add_index :done_stories, :story_id, unique: true
  end
end
