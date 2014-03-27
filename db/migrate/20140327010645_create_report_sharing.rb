class CreateReportSharing < ActiveRecord::Migration
  def change
    create_table :report_sharings do |t|
      t.references :user_profile, foreign_key: true, null: false

      t.datetime :expiration, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
