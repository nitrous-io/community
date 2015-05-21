FactoryGirl.define do
  factory :post do
    user
    type 'blog'
    sequence(:slug)  { |n| "post-slug-#{n}" }
    title 'post title'
    content_markdown 'content markdown'
    content_html 'content html'
    tag_list 'ruby'

    trait :invalid do
      title ''
    end
  end
end
