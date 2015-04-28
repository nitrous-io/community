FactoryGirl.define do
  factory :tutorial do
    user_id 1
    admin false
    author "MyString"
    slug "this-is-a-slug"
    title "MyString"
    content_markdown "MyText"
    content_html "MyText"
    approved false
  end

  trait :invalid do
    title ""
  end

end
