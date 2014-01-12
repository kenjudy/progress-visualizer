module TrelloReport
  module Constants
    
    #private
    @@user_key = 'c4ba8f697ddf1843e4ef0b84fc3aff98'
    @@readonly_token = '02436ed0c38ea018428410f835149bb2e90283f68a9771ad908bd687efc5da48'
    @@current_sprint_board_id = 'ZoCdRXWT'

    #public
    @@trello_api_root_url = "https://api.trello.com/1"
    @@trello_export_cards_path = "/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>"
  end
  
end