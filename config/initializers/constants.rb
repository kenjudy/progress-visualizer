module Trello
  module Constants
    
    TRELLO_CONFIG = YAML::load(File.open("#{Rails.root}/config/trello.yml"))
    USER_KEY = TRELLO_CONFIG['user_key']
    READONLY_TOKEN = TRELLO_CONFIG['readonly_token']
    CURRENT_SPRINT_BOARD_ID = TRELLO_CONFIG['current_sprint_board_id']

    #public
    TRELLO_API_ROOT_URL = "https://api.trello.com/1"
    TRELLO_EXPORT_ARCHIVED_CARDS_PATH = "/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>"
    TRELLO_EXPORT_CARDS_PATH = "/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>"
    TRELLO_BOARD_LISTS_PATH = "/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>"
  end
  
end