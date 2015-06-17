FactoryGirl.define do
  factory :doc_category do
    sequence(:name) { |n| "Category#{n}" }
    position 0
  end
end
