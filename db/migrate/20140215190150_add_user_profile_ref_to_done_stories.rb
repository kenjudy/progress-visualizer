class AddUserProfileRefToDoneStories < ActiveRecord::Migration
  def change
    add_reference :done_stories, :user_profile, index: true
  end
end
