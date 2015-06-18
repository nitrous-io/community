require 'rails_helper'

RSpec.describe Doc, type: :model do
  subject { create(:doc) }
  let(:user) { create(:user) }

  it_behaves_like 'likable'
  it_behaves_like 'publishable'

  describe '#grouped' do
    let!(:cat1) { create :doc_category, position: 2 }
    let!(:cat1_doc1) { create :published_doc, doc_category: cat1, position: 2 }
    let!(:cat1_doc2) { create :published_doc, doc_category: cat1, position: 3 }
    let!(:cat1_doc3) { create :published_doc, doc_category: cat1, position: 1 }
    let!(:cat1_doc4) { create :doc,           doc_category: cat1, position: 4 }

    let!(:cat2) { create :doc_category, position: 3 }
    let!(:cat2_doc1) { create :published_doc, doc_category: cat2, position: 2 }
    let!(:cat2_doc2) { create :published_doc, doc_category: cat2, position: 3 }
    let!(:cat2_doc3) { create :published_doc, doc_category: cat2, position: 1 }
    let!(:cat2_doc4) { create :doc,           doc_category: cat1, position: 4 }

    let!(:cat3) { create :doc_category, position: 1 }
    let!(:cat3_doc1) { create :published_doc, doc_category: cat3, position: 2 }
    let!(:cat3_doc2) { create :published_doc, doc_category: cat3, position: 3 }
    let!(:cat3_doc3) { create :published_doc, doc_category: cat3, position: 1 }
    let!(:cat3_doc4) { create :doc,           doc_category: cat1, position: 4 }

    it 'returns an ordered hash of docs grouped by category' do
      grouped = Doc.grouped
      expect(grouped).to be_kind_of(ActiveSupport::OrderedHash)
      expect(grouped.keys).to eq([cat3, cat1, cat2])
      expect(grouped).to eq({
        cat3 => [
          cat3_doc3,
          cat3_doc1,
          cat3_doc2
        ],
        cat1 => [
          cat1_doc3,
          cat1_doc1,
          cat1_doc2
        ],
        cat2 => [
          cat2_doc3,
          cat2_doc1,
          cat2_doc2
        ]
      })
    end

    context 'when columns argument is passed' do
       it 'fetches only specified columns' do
        grouped = Doc.grouped(%i(id slug))
        expect(grouped.keys).to eq([cat3, cat1, cat2])
        doc = grouped[cat3][0]
        expect(doc).to be_kind_of(Doc)
        expect(doc.id).to eq(cat3_doc3.id)
        expect(doc.slug).to eq(cat3_doc3.slug)
        expect{ doc.title }.to raise_error ActiveModel::MissingAttributeError
        expect{ doc.position }.to raise_error ActiveModel::MissingAttributeError
       end
    end
  end
end
