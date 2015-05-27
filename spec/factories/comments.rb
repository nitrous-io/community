FactoryGirl.define do
  factory :comment do
    user
    association :parent, factory: :post
    content 'my comments'

    trait :invalid do
      content ''
    end
  end

end
