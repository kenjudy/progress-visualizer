class AddCardIdToDoneStories < ActiveRecord::Migration
  def change
    add_reference :done_stories, :card, index: true
  end
end
