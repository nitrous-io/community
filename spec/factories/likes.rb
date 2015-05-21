FactoryGirl.define do
  factory :like do
    user
    post

    trait :invalid do
      user_id nil 
    end
  end

end
