require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { create(:comment) }

  it { should validate_presence_of(:content_markdown) }
  it { should belong_to(:parent) }

  it_behaves_like 'markdownable'
end
