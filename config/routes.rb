ProgressVisualizer::Application.routes.draw do
  
  root 'homepage#index', as: 'homepage'
  
  get 'ian4atzhmmh9ul/burn-up' => "webhooks#burn_up", format: true, constraints: { format: /json/ }
  post 'ian4atzhmmh9ul/burn-up' => "webhooks#burn_up", as: 'webhooks_burn_up', format: true, constraints: { format: /json/ }
  get 'ian4atzhmmh9ul/burn-up/add' => "webhooks#burn_up_add", as: 'webhooks_burn_up_add'
  get 'ian4atzhmmh9ul/burn-up/delete' => "webhooks#burn_up_delete", as: 'webhooks_burn_up_delete'
  
  get 'chart/burn-up' => "charts#burn_up", as: 'charts_burn_up'
  get 'chart/burn-up-reload' => "charts#burn_up_reload", as: 'charts_burn_up_reload'
  get 'chart/yesterdays-weather/(:weeks)' => "charts#yesterdays_weather", as: 'charts_yesterdays_weather', constraints: {weeks: /[0-9]*/}
  get 'chart/long-term-trend/(:weeks)' => "charts#long_term_trend", as: 'charts_long_term_trend', constraints: {weeks: /[0-9]*/}

  get 'table/done-stories' => "tables#done_stories", as: 'tables_done_stories'

  get 'report/performance-summary' => "reports#performance_summary", as: 'reports_performance_summary'

  get 'user/logout' => "users#logout", as: "users_logout"
  get 'user/forgot/:name' => "users#forgot_password", as: "users_forgot_password"
  get 'user/rplku4rpppypeu6npzwcxwxqagisaj/:name' => "users#delete", as: "users_delete"
  get 'user/Bk2meuxQzLYkdkmLsoTkVZMgfAbb9h' => "users#create", as: "users_create"
  post 'user/Bk2meuxQzLYkdkmLsoTkVZMgfAbb9h' => "users#create_submit", as: "users_create_submit"
end
