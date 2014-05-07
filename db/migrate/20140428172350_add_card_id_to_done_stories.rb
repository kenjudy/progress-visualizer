class AddCardIdToDoneStories < ActiveRecord::Migration
  def change
    add_column :done_stories, :card_id, :string, index: true
  end
end
