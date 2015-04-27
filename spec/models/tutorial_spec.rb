require 'rails_helper'

RSpec.describe Tutorial, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content_markdown) }
end
