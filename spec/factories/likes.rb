FactoryGirl.define do
  factory :like do
    user_id 1
    tutorial_id 1 

    trait :invalid do
      user_id nil 
    end
  end

end
