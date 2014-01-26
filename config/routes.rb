ProgressVisualizer::Application.routes.draw do
  
  root 'charts#daily_burnup'
  
  get 'charts/daily-burnup' => "charts#daily_burnup", as: 'charts_daily_burnup'
  get 'charts/yesterdays-weather/(:weeks)' => "charts#yesterdays_weather", as: 'charts_yesterdays_weather', constraints: {weeks: /[0-9]*/}
  get 'charts/long-term-trend/(:weeks)' => "charts#long_term_trend", as: 'charts_long_term_trend', constraints: {weeks: /[0-9]*/}
  get 'tables/overview' => "tables#overview", as: 'tables_overview'
  
end
