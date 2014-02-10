require 'bcrypt'

class UserProfile < ActiveRecord::Base
  attr_encryptor :readonly_token, :current_sprint_board_id, :current_sprint_board_id_short, :backlog_lists, :done_lists, key: :secret_key
  
  belongs_to :user

  def secret_key
    'eovnpsimvkzrahjmhoqgyeoqngabrkemoexkmzuqiqvepfqmcq'
  end
end