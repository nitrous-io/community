FactoryGirl.define do
  factory :tutorial do
    user_id 1
    admin false
    author "author"
    sequence(:slug)  { |n| "this-is-a-slug-#{n}" }
    title "title"
    content_markdown "#content"
    content_html "<h1>content</h1>"
    approved false
    score 0

    tag_list "haskell, scala"

    trait :invalid do
      title ""
    end
  end

 end
