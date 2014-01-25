class CreateDoneStories < ActiveRecord::Migration
  def change
    create_table :done_stories do |t|
      t.date :timestamp
      t.string :iteration
      t.string :type_of_work
      t.string :status
      t.string :story_id
      t.string :story
      t.float :estimate

      t.timestamps
    end
  end
end
