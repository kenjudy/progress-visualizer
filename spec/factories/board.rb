FactoryGirl.define do
  factory :board do
    skip_create
    
    ignore do
      data {{cards: [FactoryGirl.build(:card).data], lists: [FactoryGirl.build(:list).data]}}
    end

    initialize_with { Board.new(data) }
  end
end