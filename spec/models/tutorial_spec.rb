require 'rails_helper'

describe Tutorial do
  subject { create(:tutorial) }
  let(:user) { create(:user) }

  it_behaves_like 'likable'
  it_behaves_like 'publishable'
end
