FactoryGirl.define do
  factory :post do
    user
    title 'post title'
    content_markdown 'content markdown'
    tag_list 'ruby'
    published_at Time.now

    trait :invalid do
      title ''
    end
  end

  factory :published_post, parent: :post do
    state :published
  end
end
