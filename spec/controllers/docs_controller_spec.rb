require 'rails_helper'

describe DocsController do
  render_views
  let!(:cat1) { create :doc_category, position: 2 }
  let!(:cat2) { create :doc_category, position: 1 }

  describe 'GET new' do
    def do_request
      get :new
    end

    it_behaves_like 'an admin only action'

    context 'when logged in as admin' do
      before { sign_in_as_admin }

      it 'responds with new page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
        expect(assigns(:content)).to be_a Doc
        expect(assigns(:content)).to be_new_record
        expect(assigns(:categories)).to eq([cat2, cat1])
      end
    end
  end

  describe 'POST create' do
    def do_request(params = {})
      post :create, { doc: attributes_for(:doc) }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when logged in as admin' do
      before { sign_in_as_admin }

      it 'creates a doc' do
        expect {
          do_request(doc: {
            title:            'doc title',
            content_markdown: '# content markdown',
            tag_list:         'ruby',
            doc_category_id:  cat1.id
          })
        }.to change(Doc, :count).by(1)

        o = Doc.last

        expect(response).to redirect_to(doc_path(o))
        expect(o.slug).to eq('doc-title')
        expect(o.title).to eq('doc title')
        expect(o.content_markdown).to eq('# content markdown')
        expect(o.content_html).to match('<h1>content markdown</h1>')
        expect(o.content_text).to match('content markdown')
        expect(o.tag_list).to eq(['ruby'])

        expect(assigns(:content)).to be_a(Doc)
        expect(assigns(:content)).to be_persisted
        expect(assigns(:categories)).to eq([cat2, cat1])
      end
    end
  end

  describe 'GET edit' do
    render_views

    subject! { create :doc, doc_category: cat1 }

    def do_request
      get :edit, id: subject.id
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'responds with edit page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
        expect(assigns(:content)).to eq(subject)
        expect(assigns(:categories)).to eq([cat2, cat1])
      end
    end
  end

  describe 'PUT update' do
    subject! { create :doc, doc_category: cat1 }

    def do_request(params = {})
      put :update, { id: subject.id, doc: attributes_for(:doc) }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'updates the doc' do
        do_request(id: subject.id, doc: {
          title: 'updated doc title',
          content_markdown: '# updated content markdown',
          tag_list: 'rails',
          cover_image_url: 'http://example.com/a.jpg'
        })

        subject.reload

        expect(response).to redirect_to(doc_path(subject))
        expect(subject.title).to eq('updated doc title')
        expect(subject.slug).to eq('updated-doc-title')
        expect(subject.cover_image_url).to eq('http://example.com/a.jpg')
        expect(subject.content_markdown).to eq('# updated content markdown')
        expect(subject.content_html).to match('<h1>updated content markdown</h1>')
        expect(subject.content_text).to match('updated content markdown')
        expect(subject.tag_list).to eq(['rails'])

        expect(assigns(:content)).to eq(subject)
        expect(assigns(:categories)).to eq([cat2, cat1])
      end

      context 'when publish param is true' do
        it 'updates the doc and publishes the doc' do
          now = nil

          Timecop.freeze do
            now = Time.now

            do_request(id: subject.id, doc: {
              title: 'updated doc title',
              content_markdown: '# updated content markdown',
              tag_list: 'rails',
              cover_image_url: 'http://example.com/a.jpg'
            }, publish: 'true')
          end

          subject.reload

          expect(response).to redirect_to(doc_path(subject))
          expect(subject.title).to eq('updated doc title')
          expect(subject.slug).to eq('updated-doc-title')
          expect(subject.cover_image_url).to eq('http://example.com/a.jpg')
          expect(subject.content_markdown).to eq('# updated content markdown')
          expect(subject.content_html).to match('<h1>updated content markdown</h1>')
          expect(subject.content_text).to match('updated content markdown')
          expect(subject.tag_list).to eq(['rails'])

          expect(subject).to be_published
          expect(subject.published_at.to_i).to eq(now.to_i)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    subject! { create :doc, doc_category: cat1 }

    def do_request(params = {})
      delete :destroy, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'deletes the doc' do
        expect {
          do_request
        }.to change{ subject.reload.deleted? }.from(false).to(true)

        expect(response).to redirect_to(docs_path)
      end
    end
  end

  describe 'POST publish' do
    subject! { create :doc, doc_category: cat1 }

    def do_request(params = {})
      post :publish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'publishes the doc' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(false).to(true)

          expect(subject.published_at.to_i).to eq(Time.now.to_i)
        end

        expect(response).to redirect_to(doc_path(subject))
      end
    end
  end

  describe 'POST unpublish' do
    subject! { create :doc, doc_category: cat1 }
    before { subject.published! }

    def do_request(params = {})
      post :unpublish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'unpublishes the doc' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(true).to(false)

          expect(subject.published_at).to be_nil
        end

        expect(response).to redirect_to(doc_path(subject))
      end
    end
  end

  example_group do
    let!(:cat1) { create :doc_category, position: 2 }
    let!(:cat1_doc1) { create :published_doc, doc_category: cat1, position: 2, tag_list: %w(ssh) }
    let!(:cat1_doc2) { create :published_doc, doc_category: cat1, position: 1, tag_list: %w(app ide) }
    let!(:cat1_doc3) { create :published_doc, doc_category: cat1, position: 3, tag_list: %w(ide) }
    let!(:cat1_doc4) { create :doc, doc_category: cat1, tag_list: %w(ide ssh) }

    let!(:cat2) { create :doc_category, position: 1 }
    let!(:cat2_doc1) { create :published_doc, doc_category: cat2, position: 2, tag_list: %w(container) }
    let!(:cat2_doc2) { create :published_doc, doc_category: cat2, position: 1, tag_list: %w(account) }
    let!(:cat2_doc3) { create :published_doc, doc_category: cat2, position: 3, tag_list: %w(ide container) }
    let!(:cat2_doc4) { create :doc, doc_category: cat2, tag_list: %w(app ide) }

    describe 'GET index' do
      def do_request(params = {})
        get :index, params
      end

      it 'responds with index page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(assigns(:toc)).to eq({
          cat2 => [cat2_doc2, cat2_doc1, cat2_doc3],
          cat1 => [cat1_doc2, cat1_doc1, cat1_doc3]
        })
        expect(assigns(:content)).to be_blank
      end

      context 'tag is specified' do
        it 'assigns content that have specified tag' do
          do_request(tag: 'ide')
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)
          expect(assigns(:toc)).to eq({
            cat2 => [cat2_doc2, cat2_doc1, cat2_doc3],
            cat1 => [cat1_doc2, cat1_doc1, cat1_doc3]
          })
          expect(assigns(:content)).to contain_exactly(cat1_doc2, cat1_doc3, cat2_doc3)
        end
      end
    end

    describe 'GET show' do
      subject { cat1_doc1 }

      def do_request
        get :show, slug: subject.slug
      end

      it 'responds with show page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
        expect(assigns(:toc)).to eq({
          cat2 => [cat2_doc2, cat2_doc1, cat2_doc3],
          cat1 => [cat1_doc2, cat1_doc1, cat1_doc3]
        })
        expect(assigns(:content)).to eq(cat1_doc1)
      end
    end
  end

  describe 'POST like' do
    let!(:user) { create(:user) }

    subject! { create :published_doc, score: 2 }

    def do_request
      xhr :post, :like, id: subject.id
    end

    context 'when not logged in' do
      it 'returns 403 forbidden' do
        do_request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when logged in as regular user' do
      before { sign_in(user) }

      context "when user hasn't already liked the doc" do
        it 'upvotes the doc and responds with new score' do
          expect(subject.score).to eq(2)

          expect {
            do_request
          }.to change(Like, :count).by(1)

          expect(response).to have_http_status :ok
          expect(JSON.parse(response.body)).to eq('score' => 3)

          like = Like.last
          expect(like.parent_id).to eq(subject.id)
          expect(like.user_id).to eq(user.id)
          expect(subject.reload.score).to eq(3)
        end
      end

      context 'when user has already liked the doc' do
        let!(:old_like) { create :like, parent: subject, user: user }

        it 'does not re-upvote the doc, but responds with current score' do
          expect(subject.score).to eq(3)

          expect {
            do_request
          }.to change(Like, :count).by(0)

          expect(response).to have_http_status :ok
          expect(JSON.parse(response.body)).to eq('score' => 3)

          like = Like.last
          expect(like.parent_id).to eq(subject.id)
          expect(like.user_id).to eq(user.id)
          expect(subject.reload.score).to eq(3)
        end
      end
    end
  end

  describe 'POST unlike' do
    let!(:user) { create(:user) }

    subject! { create :published_doc, score: 2 }

    def do_request
      xhr :post, :unlike, id: subject.id
    end

    context 'when not logged in' do
      it 'returns 403 forbidden' do
        do_request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when logged in as regular user' do
      before { sign_in(user) }

      context "when user hasn't already liked the doc" do
        it 'does not downvote the doc, but responds with current score' do
          expect(subject.score).to eq(2)

          expect {
            do_request
          }.to change(Like, :count).by(0)

          expect(response).to have_http_status :ok
          expect(JSON.parse(response.body)).to eq('score' => 2)
          expect(subject.reload.score).to eq(2)
        end
      end

      context 'when user has already liked the doc' do
        let!(:old_like) { create :like, parent: subject, user: user }

        it 'downvotes the doc and responds with new score' do
          expect(subject.score).to eq(3)

          expect {
            do_request
          }.to change(Like, :count).by(-1)

          expect(response).to have_http_status :ok
          expect(JSON.parse(response.body)).to eq('score' => 2)
          expect(subject.reload.score).to eq(2)
        end
      end
    end
  end
end
