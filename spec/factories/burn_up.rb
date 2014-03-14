FactoryGirl.define do
  factory :burn_up do
    timestamp Date.today
    backlog 16
    done 4
    backlog_estimates 35
    done_estimates 11.5

    association :user_profile
  end
end