RSpec.configure do |config|
  config.after(:each) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end 
  end
end
