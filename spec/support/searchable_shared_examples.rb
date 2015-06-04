require 'rails_helper'

shared_examples 'searchable' do
  describe '.search' do
    let!(:beginner_go) { create(item_name, title: 'golang beginner level tutorial', content_markdown: 'go loop') }
    let!(:intermediate_go) { create(item_name, title: 'golang intermediate level tutorial', content_markdown: 'go function') }
    let!(:advanced_go) { create(item_name, title: 'golang advanced level tutorial', content_markdown: 'go channel') }

    let!(:beginner_rails) { create(item_name, title: 'rails beginner level tutorial', content_markdown: 'rails view') }
    let!(:intermediate_rails) { create(item_name, title: 'rails intermediate level tutorial', content_markdown: 'rails controller') }
    let!(:advanced_rails) { create(item_name, title: 'rails advanced level tutorial', content_markdown: 'rails model') }

    it 'searches items by keyword' do
      expect(described_class.search('golang')).to contain_exactly(beginner_go, intermediate_go, advanced_go)
    end

    it 'can accept arel' do
      beginner_go.publish_with({})
      search_with_arel = described_class.published.search('golang')
      expect(search_with_arel).to contain_exactly(beginner_go)
    end
  end
end