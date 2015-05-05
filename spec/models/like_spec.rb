require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to(:tutorial) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:tutorial_id) }
end
