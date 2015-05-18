FactoryGirl.define do
  factory :image do
    file_name { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'mock-image.jpg')) }

    trait :invalid do
      file_name nil
    end
  end

end
