require 'bcrypt'

class UserProfile < ActiveRecord::Base
  attr_encryptor :readonly_token, :current_sprint_board_id, :current_sprint_board_id_short, :backlog_lists, :done_lists, key: 'eovnpsimvkzrahjmhoqgyeoqngabrkemoexkmzuqiqvepfqmcq'
  
  belongs_to :user

  
end