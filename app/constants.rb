module TrelloReport
  module Constants
    
    TRELLO_CONFIG = YAML::load(File.open("app/trello.yml"))
    @@user_key = TRELLO_CONFIG['user_key']
    @@readonly_token = TRELLO_CONFIG['readonly_token']
    @@current_sprint_board_id = TRELLO_CONFIG['current_sprint_board_id']

    #public
    @@trello_api_root_url = "https://api.trello.com/1"
    @@trello_export_cards_path = "/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>"
  end
  
end