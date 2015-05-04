require 'rails_helper'

RSpec.describe Blog, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content_markdown) }

  it { should validate_uniqueness_of(:slug) }
end
