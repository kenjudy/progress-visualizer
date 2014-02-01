ProgressVisualizer::Application.routes.draw do
  
  root 'homepage#index', as: 'homepage'
  
  get 'chart/burn-up' => "charts#burn_up", as: 'charts_burn_up'
  get 'chart/yesterdays-weather/(:weeks)' => "charts#yesterdays_weather", as: 'charts_yesterdays_weather', constraints: {weeks: /[0-9]*/}
  get 'chart/long-term-trend/(:weeks)' => "charts#long_term_trend", as: 'charts_long_term_trend', constraints: {weeks: /[0-9]*/}

  get 'table/overview' => "tables#overview", as: 'tables_overview'

  get 'user/logout' => "users#logout", as: "users_logout"
  get 'user/forgot/:name' => "users#forgot_password", as: "users_forgot_password"
  get 'user/rplku4rpppypeu6npzwcxwxqagisaj' => "users#delete", as: "users_delete"
  get 'user/Bk2meuxQzLYkdkmLsoTkVZMgfAbb9h' => "users#create", as: "users_create"
  post 'user/Bk2meuxQzLYkdkmLsoTkVZMgfAbb9h' => "users#create_submit", as: "users_create_submit"
end
