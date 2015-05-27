require 'rails_helper'

describe Post do
  subject { create(:post) }
  let(:user) { create(:user) }

  it_behaves_like 'likable'
end
