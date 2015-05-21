FactoryGirl.define do
  factory :comment do
    author "MyString"
    post
    content "MyText"

    trait :invalid do
      content ""
    end
  end

end
