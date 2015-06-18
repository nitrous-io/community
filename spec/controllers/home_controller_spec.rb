require 'rails_helper'

describe HomeController do
  describe 'GET #index' do
    render_views

    let!(:post1) { create(:published_post, published_at: 3.hours.ago) }
    let!(:post2) { create(:published_post, published_at: 1.hour.ago ) }
    let!(:post3) { create(:published_post, published_at: 2.hours.ago) }
    let!(:post4) { create(:post) }
    let!(:tutorial1) { create(:published_tutorial, published_at: 3.hours.ago ) }
    let!(:tutorial2) { create(:published_tutorial, published_at: 1.hour.ago  ) }
    let!(:tutorial3) { create(:published_tutorial, published_at: 2.hours.ago ) }
    let!(:tutorial4) { create(:tutorial) }

    let!(:cat1) { create :doc_category, position: 2 }
    let!(:cat1_doc1) { create :published_doc, doc_category: cat1, position: 2 }
    let!(:cat1_doc2) { create :published_doc, doc_category: cat1, position: 1 }
    let!(:cat1_doc3) { create :published_doc, doc_category: cat1, position: 3 }
    let!(:cat1_doc4) { create :doc, doc_category: cat1 }

    let!(:cat2) { create :doc_category, position: 1 }
    let!(:cat2_doc1) { create :published_doc, doc_category: cat2, position: 2 }
    let!(:cat2_doc2) { create :published_doc, doc_category: cat2, position: 1 }
    let!(:cat2_doc3) { create :published_doc, doc_category: cat2, position: 3 }
    let!(:cat2_doc4) { create :doc, doc_category: cat2 }

    def do_request
      get :index
    end

    it 'renders published posts and tutorials' do
      do_request
      expect(response).to be_success
      expect(assigns(:posts)).to eq([post2, post3, post1])
      expect(assigns(:tutorials)).to eq([tutorial2, tutorial3, tutorial1])
      expect(assigns(:docs_toc)).to eq({
        cat2 => [cat2_doc2, cat2_doc1, cat2_doc3],
        cat1 => [cat1_doc2, cat1_doc1, cat1_doc3]
      })
    end
  end
end
