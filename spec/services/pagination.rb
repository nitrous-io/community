require 'rails_helper'

describe Pagination do
  let!(:item1) { create(:post, title: '1 item') }
  let!(:item2) { create(:post, title: '2 item') }
  let!(:item3) { create(:post, title: '3 item') }
  let!(:item4) { create(:post, title: '4 item') }
  let!(:item5) { create(:post, title: '5 item') }

  let(:collection) { Post.order(title: :asc) }

  describe '#item' do
    it 'returns items for current page' do
      subject = described_class.new(collection, { page: 1, per_page: 3}).items
      expect(subject).to contain_exactly(item1, item2, item3)

      subject = described_class.new(collection, page: 2, per_page: 3).items
      expect(subject).to contain_exactly(item4, item5)

      subject = described_class.new(collection, page: 3, per_page: 3).items
      expect(subject).to be_empty
    end
  end

  describe '#more?' do
    it 'returns true when it has items for next page' do
      expect(described_class.new(collection, page: 1, per_page: 3)).to be_more
      expect(described_class.new(collection, page: 2, per_page: 3)).not_to be_more
    end
  end

  describe '#options_for_next_page' do
    it 'returns options for next page' do
      expect(
          described_class.new(collection, page: 1, per_page: 3).options_for_next_page
      ).to eq({page: 2, per_page: 3})
      expect(
          described_class.new(collection, page: 2, per_page: 3).options_for_next_page
      ).to eq({page: 3, per_page: 3})
    end
  end
end
