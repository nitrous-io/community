require 'rails_helper'

describe Post do
  subject { create(:post) }
  let(:user) { create(:user) }

  it_behaves_like 'likable'
  it_behaves_like 'publishable'
  it_behaves_like 'searchable' do
    let(:item_name) { :post }
  end
end
