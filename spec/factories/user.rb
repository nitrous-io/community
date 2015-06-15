FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| n + 1 }
    username 'username'
    nitrous_oauth_token 'token'
    email 'user@example.com'
    admin false
    last_fetched_at { Time.now }

    trait :invalid do
      username nil
    end
  end
end
