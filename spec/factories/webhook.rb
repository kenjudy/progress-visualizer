FactoryGirl.define do
  factory :webhook do
    id_model "52e6778d5922b7e16a641e58"
    callback_url "http://www.progress-visualizer.com/ian4atzhmmh9ul/burn-up/2.json"
    association :user_profile    
  end
end