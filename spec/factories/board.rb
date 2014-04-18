FactoryGirl.define do
  factory :board do
    skip_create
    
    data {{cards: [FactoryGirl.build(:card).data], lists: [FactoryGirl.build(:list).data]}}

    initialize_with { Board.new(data) }
  end
end