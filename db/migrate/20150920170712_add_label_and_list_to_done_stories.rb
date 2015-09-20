class AddLabelAndListToDoneStories < ActiveRecord::Migration
  def change
    add_column :done_stories, :list_name, :string
    add_column :done_stories, :label_names, :string
  end
end
