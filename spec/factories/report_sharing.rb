FactoryGirl.define do
  factory :report_sharing do
    
    expiration Time.now + 1.week
    url "/report/performance-summary"
    guid SecureRandom.uuid

    association :user_profile
  end
end
