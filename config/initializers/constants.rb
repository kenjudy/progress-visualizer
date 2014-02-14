module Constants

  TRELLO_CONFIG = YAML::load(File.open("#{Rails.root}/config/trello.yml"))
  
  Rails.application.config.trello = { 
            app_key: TRELLO_CONFIG['application']['key'],
            readonly_token: TRELLO_CONFIG['user']['readonly_token'],
            #public
            api_root_url: "https://api.trello.com/1",
            trello_root_url: "https://trello.com/1",
            export_archived_cards_path: "/boards/<BOARD_ID>/cards/closed?key=<KEY>&token=<TOKEN>",
            export_cards_path: "/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>",
            board_lists_path: "/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>",
            board_meta_path: "/boards/<BOARD_ID>?key=<KEY>&token=<TOKEN>",
            add_webhooks_path: "/tokens/<TOKEN>/webhooks/?key=<KEY>",
            request_token_path: "/authorize?key=<KEY>&name=ProgressVisualizer&expiration=never&response_type=token&scope=read"
           }
  

  Rails.application.config.adapter = ::Adapters::TrelloAdapter.new
    
  Rails.application.config.email_default_from = "progress-visualizer@judykat.com"
    
  Rails.application.config.current_sprint_board = {id: TRELLO_CONFIG['user']['current_sprint_board']['id'],
                                                   backlog_lists: TRELLO_CONFIG['user']['current_sprint_board']['backlog_lists'].merge(TRELLO_CONFIG['user']['current_sprint_board']['done_lists']),
                                                   done_lists: TRELLO_CONFIG['user']['current_sprint_board']['done_lists'],
                                                   labels_types_of_work: TRELLO_CONFIG['user']['current_sprint_board']['labels_types_of_work']}

  ITERATION_CONFIG = YAML::load(File.open("#{Rails.root}/config/iteration.yml"))
  
  if ITERATION_CONFIG['user']['duration'] == "WEEKLY"
    start_day_of_week = ITERATION_CONFIG['user']['start_day_of_week'] ||= 1
    start_hour = ITERATION_CONFIG['user']['start_hour'] ||= 0
    end_day_of_week = ITERATION_CONFIG['user']['end_day_of_week'] ||= 6
    end_day_of_week = end_day_of_week + 8 if end_day_of_week <= start_day_of_week 
    end_hour = ITERATION_CONFIG['user']['end_hour'] ||= 0
    
    Rails.application.config.iteration_start = Time.zone.local_to_utc(Date.today.end_of_week.to_datetime - (7 - start_day_of_week).days +  start_hour.hours)
    Rails.application.config.iteration_end = Time.zone.local_to_utc(Date.today.end_of_week.to_datetime - (7 - end_day_of_week).days +  end_hour.hours)
  end

end