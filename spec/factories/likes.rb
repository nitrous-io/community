FactoryGirl.define do
  factory :like do
    user
    tutorial

    trait :invalid do
      user_id nil 
    end
  end

end
