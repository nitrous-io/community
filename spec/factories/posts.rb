FactoryGirl.define do
  factory :post do
    user
    title 'post title'
    content_markdown 'content markdown'
    tag_list 'ruby'

    trait :invalid do
      title ''
    end
  end
end
