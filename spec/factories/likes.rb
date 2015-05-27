FactoryGirl.define do
  factory :like do
    user
    association :parent, factory: :post

    trait :invalid do
      user_id nil 
    end
  end

end
