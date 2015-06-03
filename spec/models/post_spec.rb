require 'rails_helper'

describe Post do
  subject { create(:post) }
  let(:user) { create(:user) }

  it_behaves_like 'likable'
  it_behaves_like 'publishable'
end
