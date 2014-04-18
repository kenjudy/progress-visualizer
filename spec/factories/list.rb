FactoryGirl.define do
  factory :list do
    skip_create
    
    data {{"id"=>"52653272e6fa31217b001705", "name"=>"Ready for Development"}}

    initialize_with { List.new(data) }
  end
end