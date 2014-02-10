class CreateUserProfile < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      
      t.references :user, :foreign_key => true, :null => false

      t.string :encrypted_readonly_token
      t.string :encrypted_current_sprint_board_id
      t.string :encrypted_current_sprint_board_id_short
      t.string :encrypted_backlog_lists
      t.string :encrypted_done_lists
      
      t.string :encrypted_readonly_token_iv
      t.string :encrypted_current_sprint_board_id_iv
      t.string :encrypted_current_sprint_board_id_short_iv
      t.string :encrypted_backlog_lists_iv
      t.string :encrypted_done_lists_iv
      
      t.string :encrypted_readonly_token_salt
      t.string :encrypted_current_sprint_board_id_salt
      t.string :encrypted_current_sprint_board_id_short_salt
      t.string :encrypted_backlog_lists_salt
      t.string :encrypted_done_lists_salt

      t.string :labels_types_of_work
 
      t.string  :duration
      t.integer :start_day_of_week
      t.integer :end_day_of_week
      t.integer :start_hour
      t.integer :end_hour

      t.timestamps
      
    end
  end
end
