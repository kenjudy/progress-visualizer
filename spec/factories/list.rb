FactoryGirl.define do
  factory :list do
    skip_create
    
    ignore do
      data {{"id"=>"52653272e6fa31217b001705", "name"=>"Ready for Development"}}
    end

    initialize_with { List.new(data) }
  end
end