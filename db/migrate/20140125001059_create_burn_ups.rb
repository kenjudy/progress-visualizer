class CreateBurnUps < ActiveRecord::Migration
  def change
    create_table :burn_ups do |t|
      t.datetime :timestamp
      t.integer :backlog
      t.integer :done
      t.float :backlog_estimates
      t.float :done_estimates
      t.timestamps
    end
  end
end
