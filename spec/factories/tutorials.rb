FactoryGirl.define do
  factory :tutorial do
    id 1
    user_id 1
    admin false
    author "author"
    slug "this-is-a-slug"
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
