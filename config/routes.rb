ProgressVisualizer::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'homepage#index', as: 'homepage'

  get "about" => "about#index", as: "about"
  get "privacy-policy" => "about#privacy_policy", as: "privacy_policy"
  get "terms-and-conditions" => "about#terms_and_conditions", as: "terms_and_conditions"
  get "release-notes" => "about#release_notes", as: "release_notes"

  get "help" => "help#index", as: "help_index"

  get "contact_form/new", as: "contact_form_new"
  post "contact_form/create", as: "contact_form_create"

  resources :user_profiles
  
  get "user_profiles/set/:profile_id" => "user_profiles#set", as: 'set_user_profile'

  get  'ian4atzhmmh9ul/burn-up/:profile_id' => "webhooks#burn_up", format: true, constraints: { format: /json/ }
  post 'ian4atzhmmh9ul/burn-up/:profile_id' => "webhooks#burn_up", as: 'webhooks_burn_up', format: true, constraints: { format: /json/ }

  get 'cards/:card_id' => "cards#show", as: 'cards_show'

  get 'chart/burn-up/(:iteration)' => "charts#burn_up", as: 'charts_burn_up'
  get 'chart/burn-up-reload' => "charts#burn_up_reload", as: 'charts_burn_up_reload'
  get 'chart/yesterdays-weather/(:weeks)' => "charts#yesterdays_weather", as: 'charts_yesterdays_weather', constraints: {weeks: /[0-9]*/}
  get 'chart/long-term-trend/(:weeks)' => "charts#long_term_trend", as: 'charts_long_term_trend', constraints: {weeks: /[0-9]*/}

  get 'table/done-stories/(:iteration)' => "tables#done_stories", as: 'tables_done_stories'
  get 'table/todo-stories' => "tables#todo_stories", as: 'tables_todo_stories'

  get 'report/performance-summary/(:iteration)' => "reports#performance_summary", as: 'reports_performance_summary'
  post 'report/sharing/:report/new' => "reports#sharing_new", as: 'reports_sharing_new', constraints: { report: /performance-summary/ }
  get 'report/sharing/:guid' => "reports#sharing", as: 'reports_sharing'

  get 'admin/users' => 'admin#users', as: 'admin_users'
  get 'admin/cards' => 'admin#cards', as: 'admin_cards'
end
