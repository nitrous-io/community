FactoryGirl.define do
  factory :tutorial do
    user
    title 'tutorial title'
    content_markdown 'content markdown'
    tag_list 'ruby'

    trait :invalid do
      title ''
    end
  end
end
