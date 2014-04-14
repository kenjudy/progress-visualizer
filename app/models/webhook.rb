class Webhook < ActiveRecord::Base
  belongs_to :user_profile

  validates :user_profile, :callback_url, :id_model, presence: true
  validate :unique_callback, on: :create

  before_create :add_webhook
  before_destroy :destroy_webhook
  
  def add_webhook
    webhook_attr = BaseAdapter.build_adapter(user_profile).add_webhook(callback_url, user_profile.current_sprint_board_id)
    self.external_id = webhook_attr["id"]
    self.description = webhook_attr["description"]
  end
  
  def destroy_webhook
    BaseAdapter.build_adapter(user_profile).destroy_webhook(self.external_id)
  end
  
  def unique_callback
    errors.add(:callback_url, "is not unique for #{user_profile.name}") if Webhook.find_by(user_profile: user_profile, callback_url: callback_url)
  end
end
