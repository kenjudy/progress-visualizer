module Constants

  TRELLO_CONFIG = YAML::load(File.open("#{Rails.root}/config/trello.yml"))
  
  Rails.application.config.trello = { 
            app_key: TRELLO_CONFIG['application']['key'],
            #public
            api_root_url: "https://api.trello.com/1",
            trello_root_url: "https://trello.com/1",
            export_all_cards_path: "/boards/<BOARD_ID>/cards/all?key=<KEY>&token=<TOKEN>",
            export_cards_path: "/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>",
            board_lists_path: "/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>",
            board_meta_path: "/boards/<BOARD_ID>?key=<KEY>&token=<TOKEN>",
            add_webhooks_path: "/tokens/<TOKEN>/webhooks/?key=<KEY>",
            manage_webhooks_path: "/webhooks/<WEBHOOK_ID>?key=<KEY>&token=<TOKEN>",
            request_token_path: "/authorize?key=<KEY>&name=ProgressVisualizer&expiration=never&response_type=token"
           }
  

  Rails.application.config.adapter_class = "::Adapters::TrelloAdapter"
    
  Rails.application.config.email_default_from = "progress-visualizer@judykat.com"

end