module Constants

  TRELLO_CONFIG = YAML::load(File.open("#{Rails.root}/config/trello.yml"))

  Rails.application.config.trello = {
    app_key: TRELLO_CONFIG['application']['key'],
    secret: TRELLO_CONFIG['application']['secret'],
    #public
    api_root_url: "https://api.trello.com/1",
    trello_root_url: "https://trello.com/1",
    export_all_cards_path: "/boards/<BOARD_ID>/cards/all?key=<KEY>&token=<TOKEN>",
    export_cards_path: "/boards/<BOARD_ID>/cards?key=<KEY>&token=<TOKEN>",
    card_path: "/cards/<CARD_ID>?key=<KEY>&token=<TOKEN>",
    card_activities_path: "/cards/<CARD_ID>/actions?key=<KEY>&token=<TOKEN>",
    board_lists_path: "/boards/<BOARD_ID>/lists?key=<KEY>&token=<TOKEN>",
    board_meta_path: "/boards/<BOARD_ID>?key=<KEY>&token=<TOKEN>",
    add_webhooks_path: "/tokens/<TOKEN>/webhooks/?key=<KEY>",
    manage_webhooks_path: "/webhooks/<WEBHOOK_ID>?key=<KEY>&token=<TOKEN>",
    request_token_path: "/authorize?key=<KEY>&name=ProgressVisualizer&expiration=never&response_type=token"
  }

  TWITTER_CONFIG = YAML::load(File.open("#{Rails.root}/config/twitter.yml"))

  Rails.application.config.twitter = {
    app_key: TWITTER_CONFIG['application']['key'],
    secret: TWITTER_CONFIG['application']['secret'],
  }
  
  GOOGLE_CONFIG = YAML::load(File.open("#{Rails.root}/config/google.yml"))
  
  Rails.application.config.google = {
    client_id: GOOGLE_CONFIG['application'][Rails.env]['client_id'],
    secret: GOOGLE_CONFIG['application'][Rails.env]['secret'],
  }

  Rails.application.config.adapter_class = "::TrelloAdapter"

  Rails.application.config.email_default_from = "progress-visualizer@judykat.com"

  BITLY_CONFIG = YAML::load(File.open("#{Rails.root}/config/bitly.yml"))
  Rails.application.config.bitly = { 
    token: BITLY_CONFIG['application']['token'],
    save_link_url: "https://api-ssl.bitly.com/v3/user/link_save?private=true&title=Saved%20Progress%20Visualizer%20Report&access_token=<TOKEN>&longUrl="
  }
end