FactoryGirl.define do
  factory :yesterdays_weather_chart do
    skip_create
    
    initialize_with { YesterdaysWeatherChart.new([FactoryGirl.build(:user_profile)], { weeks: 10, label: 'stories' }) }
  end
end