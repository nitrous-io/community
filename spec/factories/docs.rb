FactoryGirl.define do
  factory :doc do
    user
    doc_category
    sequence(:title) { |n| "Doc #{n}" }
    content_markdown 'content markdown'
    tag_list 'ruby'
    published_at nil

    trait :invalid do
      title ''
    end
  end

  factory :published_doc, parent: :doc do
    state :published
    published_at { Time.now }
  end
end
