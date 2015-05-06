FactoryGirl.define do
  factory :tutorial do
    user_id 1
    admin false
    author "author"
    slug "this-is-a-slug"
    title "title"
    content_markdown "#content"
    content_html "<h1>content</h1>"
    approved false

    tag_list "haskell, scala"

    trait :invalid do
      title ""
    end
  end

 end
