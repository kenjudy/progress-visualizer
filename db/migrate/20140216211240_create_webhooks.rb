class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.references :user_profile, index: true
      t.string :external_id
      t.string :callback_url
      t.string :id_model
      t.string :description
      t.string :last_run
      
      t.timestamps
    end
  end
end
