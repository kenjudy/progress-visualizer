FactoryGirl.define do
  factory :done_story do
    timestamp Date.today
    iteration Date.today.end_of_week - 6.days
    type_of_work "Committed"
    status "This Sprint - Pending Deploy"
    sequence(:story_id)
    story "Story name"
    estimate 1

    association :user_profile
  end
end