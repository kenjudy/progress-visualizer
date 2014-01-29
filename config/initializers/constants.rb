module Constants

  TRELLO_CONFIG = YAML::load(File.open("#{Rails.root}/config/trello.yml"))
  
  TRELLO = { 
            user_key: TRELLO_CONFIG['user_key'],
            readonly_token: TRELLO_CONFIG['readonly_token'],
            #public
            api_root_url: "https://api.trello.com/1",
            export_archived_cards_path: "/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>",
            export_cards_path: "/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>",
            board_lists_path: "/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>"
           }
  
  CURRENT_SPRINT_BOARD = { id: TRELLO_CONFIG['current_sprint_board']['id'],
                           backlog_list_ids: TRELLO_CONFIG['current_sprint_board']['backlog_lists'] + TRELLO_CONFIG['current_sprint_board']['done_lists'],
                           done_list_ids: TRELLO_CONFIG['current_sprint_board']['done_lists'],
                           labels_types_of_work: TRELLO_CONFIG['current_sprint_board']['labels_types_of_work']}


  ITERATION_CONFIG = YAML::load(File.open("#{Rails.root}/config/iteration.yml"))
  
  ITERATION = {}
  
  if ITERATION_CONFIG['duration'] == "WEEKLY" && ITERATION_CONFIG['start_day_of_week'] == 1
    ITERATION[:iteration_start] = Date.today.end_of_week - 6.days
    ITERATION[:iteration_end] = Date.today.end_of_week
  end
end