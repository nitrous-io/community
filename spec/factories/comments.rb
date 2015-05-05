FactoryGirl.define do
  factory :comment do
    author "MyString"
    tutorial_id 2 
    content "MyText"

    trait :invalid do
      content ""
    end
  end

end
