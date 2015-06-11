FactoryGirl.define do
  factory :comment do
    user
    association :parent, factory: :post
    content_markdown 'my comments'

    trait :invalid do
      content ''
    end
  end

end
