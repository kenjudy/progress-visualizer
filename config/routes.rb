ProgressVisualizer::Application.routes.draw do
  
  devise_for :users
  root 'homepage#index', as: 'homepage'
  
  resources :user_profiles
  resources :webhooks

  get "user_profiles/set/:profile_id" => "user_profiles#set", as: 'set_user_profile'
  
  get  'ian4atzhmmh9ul/burn-up/:profile_id(.:format)' => "webhooks#burn_up", format: true, constraints: { format: /json/ }
  post 'ian4atzhmmh9ul/burn-up/:profile_id(.:format)' => "webhooks#burn_up", as: 'webhooks_burn_up', format: true, constraints: { format: /json/ }
  
  get 'chart/burn-up/(:iteration)' => "charts#burn_up", as: 'charts_burn_up'
  get 'chart/burn-up-reload' => "charts#burn_up_reload", as: 'charts_burn_up_reload'
  get 'chart/yesterdays-weather/(:weeks)' => "charts#yesterdays_weather", as: 'charts_yesterdays_weather', constraints: {weeks: /[0-9]*/}
  get 'chart/long-term-trend/(:weeks)' => "charts#long_term_trend", as: 'charts_long_term_trend', constraints: {weeks: /[0-9]*/}

  get 'table/done-stories' => "tables#done_stories", as: 'tables_done_stories'

  get 'report/performance-summary' => "reports#performance_summary", as: 'reports_performance_summary'

end
