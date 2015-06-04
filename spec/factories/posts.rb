FactoryGirl.define do
  factory :post do
    user
    title 'post title'
    content_markdown 'content markdown'
    tag_list 'ruby'
    published_at nil

    trait :invalid do
      title ''
    end
  end

  factory :published_post, parent: :post do
    state :published
    published_at Time.now
  end
end
