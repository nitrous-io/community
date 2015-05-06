FactoryGirl.define do
  factory :blog do
    author "mary"
    slug "this-is-a-slug"
    title "this is a title"
    content_markdown "content markdown"
    content_html "content html"

    tag_list "ruby"

    trait :invalid do
      title ""
    end

  end
end
