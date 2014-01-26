ProgressVisualizer::Application.routes.draw do
  
  root 'charts#daily_burnup'
  
  get 'charts/daily-burnup' => "charts#daily_burnup", as: 'charts_daily_burnup'
  get 'charts/yesterdays-weather' => "charts#yesterdays_weather", as: 'charts_yesterdays_weather'
  get 'charts/long-term-trend' => "charts#long_term_trend", as: 'charts_long_term_trend'
  get 'tables/overview' => "tables#overview", as: 'tables_overview'
  
end
