class AddUserProfileRefToBurnUps < ActiveRecord::Migration
  def change
    add_reference :burn_ups, :user_profile, index: true
  end
end
