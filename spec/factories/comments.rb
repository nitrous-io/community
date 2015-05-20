FactoryGirl.define do
  factory :comment do
    author "MyString"
    tutorial
    content "MyText"

    trait :invalid do
      content ""
    end
  end

end
