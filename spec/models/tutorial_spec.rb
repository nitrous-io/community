require 'rails_helper'

RSpec.describe Tutorial, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content_markdown) }

  it { should validate_uniqueness_of(:slug) }

  it { should have_many(:comments) }
  it { should have_many(:likes) }
end
