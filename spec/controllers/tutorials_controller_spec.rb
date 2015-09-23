require 'rails_helper'

describe TutorialsController do
  render_views

  describe 'GET new' do
    def do_request
      get :new
    end

    it_behaves_like 'an admin or editor only action'

    context 'when logged in as admin' do
      before { sign_in_as_editor }

      it 'responds with new page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end

    context 'when logged in as editor' do
      before { sign_in_as_editor }

      it 'responds with new page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST create' do
    def do_request(params = {})
      post :create, { tutorial: attributes_for(:tutorial) }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when logged in as admin' do
      before { sign_in_as_admin }

      it 'creates a tutorial' do
        expect {
          do_request(tutorial: {
            title:            'tutorial title',
            content_markdown: '# content markdown',
            tag_list:         'ruby'
          })
        }.to change(Tutorial, :count).by(1)

        o = Tutorial.last

        expect(response).to redirect_to(tutorial_path(o))
        expect(o.slug).to eq('tutorial-title')
        expect(o.title).to eq('tutorial title')
        expect(o.content_markdown).to eq('# content markdown')
        expect(o.content_html).to match('<h1>content markdown</h1>')
        expect(o.content_text).to match('content markdown')
        expect(o.tag_list).to eq(['ruby'])
      end
    end

    context 'when logged in as editor' do
      before { sign_in_as_editor }

      it 'creates a tutorial' do
        expect {
          do_request(tutorial: {
            title:            'tutorial title',
            content_markdown: '# content markdown',
            tag_list:         'ruby'
          })
        }.to change(Tutorial, :count).by(1)

        o = Tutorial.last

        expect(response).to redirect_to(tutorial_path(o))
        expect(o.slug).to eq('tutorial-title')
        expect(o.title).to eq('tutorial title')
        expect(o.content_markdown).to eq('# content markdown')
        expect(o.content_html).to match('<h1>content markdown</h1>')
        expect(o.content_text).to match('content markdown')
        expect(o.tag_list).to eq(['ruby'])
      end
    end
  end

  describe 'GET edit' do
    render_views

    subject { create :tutorial }

    def do_request
      get :edit, id: subject.id
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_admin }

      it 'responds with edit page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end

    context 'when user is logged in as editor' do
      before { sign_in_as_editor }

      it 'responds with edit page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT update' do
    subject! { create :tutorial }

    def do_request(params = {})
      put :update, { id: subject.id, tutorial: attributes_for(:tutorial) }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_admin }

      it 'updates the tutorial' do
        do_request(id: subject.id, tutorial: {
          title: 'updated tutorial title',
          content_markdown: '# updated content markdown',
          tag_list: 'rails',
          cover_image_url: 'http://example.com/a.jpg'
        })

        subject.reload

        expect(response).to redirect_to(tutorial_path(subject))
        expect(subject.title).to eq('updated tutorial title')
        expect(subject.slug).to eq('updated-tutorial-title')
        expect(subject.cover_image_url).to eq('http://example.com/a.jpg')
        expect(subject.content_markdown).to eq('# updated content markdown')
        expect(subject.content_html).to match('<h1>updated content markdown</h1>')
        expect(subject.content_text).to match('updated content markdown')
        expect(subject.tag_list).to eq(['rails'])
      end

      context 'when publish param is true' do
        it 'updates the tutorial and publishes the tutorial' do
          now = nil

          Timecop.freeze do
            now = Time.now

            do_request(id: subject.id, tutorial: {
              title: 'updated tutorial title',
              content_markdown: '# updated content markdown',
              tag_list: 'rails',
              cover_image_url: 'http://example.com/a.jpg'
            }, publish: 'true')
          end

          subject.reload

          expect(response).to redirect_to(tutorial_path(subject))
          expect(subject.title).to eq('updated tutorial title')
          expect(subject.slug).to eq('updated-tutorial-title')
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

    context 'when user is logged in as editor' do
      before { sign_in_as_editor }

      it 'updates the tutorial' do
        do_request(id: subject.id, tutorial: {
          title: 'updated tutorial title',
          content_markdown: '# updated content markdown',
          tag_list: 'rails',
          cover_image_url: 'http://example.com/a.jpg'
        })

        subject.reload

        expect(response).to redirect_to(tutorial_path(subject))
        expect(subject.title).to eq('updated tutorial title')
        expect(subject.slug).to eq('updated-tutorial-title')
        expect(subject.cover_image_url).to eq('http://example.com/a.jpg')
        expect(subject.content_markdown).to eq('# updated content markdown')
        expect(subject.content_html).to match('<h1>updated content markdown</h1>')
        expect(subject.content_text).to match('updated content markdown')
        expect(subject.tag_list).to eq(['rails'])
      end

      context 'when publish param is true' do
        it 'updates the tutorial and publishes the tutorial' do
          now = nil

          Timecop.freeze do
            now = Time.now

            do_request(id: subject.id, tutorial: {
              title: 'updated tutorial title',
              content_markdown: '# updated content markdown',
              tag_list: 'rails',
              cover_image_url: 'http://example.com/a.jpg'
            }, publish: 'true')
          end

          subject.reload

          expect(response).to redirect_to(tutorial_path(subject))
          expect(subject.title).to eq('updated tutorial title')
          expect(subject.slug).to eq('updated-tutorial-title')
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
    subject! { create :tutorial }

    def do_request(params = {})
      delete :destroy, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_admin }

      it 'deletes the tutorial' do
        expect {
          do_request
        }.to change{ subject.reload.deleted? }.from(false).to(true)

        expect(response).to redirect_to(tutorials_path)
      end
    end

    context 'when user is logged in as editor' do
      before { sign_in_as_editor }

      it 'deletes the tutorial' do
        expect {
          do_request
        }.to change{ subject.reload.deleted? }.from(false).to(true)

        expect(response).to redirect_to(tutorials_path)
      end
    end
  end

  describe 'POST publish' do
    subject! { create :tutorial }

    def do_request(params = {})
      post :publish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_admin }

      it 'publishes the tutorial' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(false).to(true)

          expect(subject.published_at.to_i).to eq(Time.now.to_i)
        end

        expect(response).to redirect_to(tutorial_path(subject))
      end
    end

    context 'when user is logged in as editor' do
      before { sign_in_as_editor }

      it 'publishes the tutorial' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(false).to(true)

          expect(subject.published_at.to_i).to eq(Time.now.to_i)
        end

        expect(response).to redirect_to(tutorial_path(subject))
      end
    end
  end

  describe 'POST unpublish' do
    subject! { create :tutorial }
    before { subject.published! }

    def do_request(params = {})
      post :unpublish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_admin }

      it 'unpublishes the tutorial' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(true).to(false)

          expect(subject.published_at).to be_nil
        end

        expect(response).to redirect_to(tutorial_path(subject))
      end
    end
 
    context 'when user is logged in as editor' do
      before { sign_in_as_editor }

      it 'unpublishes the tutorial' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(true).to(false)

          expect(subject.published_at).to be_nil
        end

        expect(response).to redirect_to(tutorial_path(subject))
      end
    end
  end

  describe 'GET index' do
    let!(:rust_tutorial)  { create(:tutorial, title: 'rust', tag_list: %w(rust go)) }
    let!(:rails_tutorial) { create(:published_tutorial, published_at: 1.hour.ago,  title: 'rails-tutorial', tag_list: %w(rails ruby)) }
    let!(:go_tutorial)    { create(:published_tutorial, published_at: 2.hours.ago, title: 'go-tutorial',    tag_list: %w(go martini)) }
    let!(:java_tutorial)  { create(:published_tutorial, published_at: 3.hours.ago, title: 'java-tutorial',  tag_list: %w(java      )) }
    let!(:js_tutorial)    { create(:published_tutorial, published_at: 4.hours.ago, title: 'js-tutorial',    tag_list: %w(javascript)) }
    let!(:cgo_tutorial)   { create(:published_tutorial, published_at: 5.hours.ago, title: 'cgo-tutorial',   tag_list: %w(go c      )) }

    def do_request(params = {})
      get :index, params
    end

    it 'responds with index page' do
      do_request
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    [nil, 1].each do |page|
      context "when page == #{page}" do
        it 'assigns content' do
          do_request(page: page, per_page: 2)
          expect(assigns(:content).map(&:id)).to eq([rails_tutorial, go_tutorial].map(&:id))
        end
      end
    end

    context 'when page > 1 is requested' do
      it 'assigns content' do
        do_request(page: 2, per_page: 2)
        expect(assigns(:content).map(&:id)).to eq([java_tutorial, js_tutorial].map(&:id))
      end
    end

    context 'tag is specified' do
      it 'assigns content that have specified tag' do
        do_request(tag: 'go')
        expect(assigns(:content).map(&:id)).to eq([go_tutorial, cgo_tutorial].map(&:id))
      end
    end
  end

  describe 'GET show' do
    subject(:published_tutorial) { create :published_tutorial }
    subject(:tutorial) { create :tutorial }

    def do_request(params={})
      get :show, { slug: published_tutorial.slug }.merge(params)
    end

    context 'when published tutorial is requested' do
      context 'when logged in as admin' do
        before { sign_in_as_admin }

        it 'responds with show page' do
          do_request(slug: published_tutorial.slug)
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to include("Edit Tutorial")
          expect(response.body).to include("Unpublish")
          expect(response.body).to_not include("Publish")
          expect(response.body).to include("Drafts")
        end
      end

      context 'when logged in as editor' do
        before { sign_in_as_editor }

        it 'responds with show page' do
          do_request(slug: published_tutorial.slug)
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to include("Edit Tutorial")
          expect(response.body).to include("Unpublish")
          expect(response.body).to_not include("Publish")
          expect(response.body).to include("Drafts")
        end
      end

      context 'when logged in as regular user' do
        before { sign_in }

        it 'responds with show page' do
          do_request(slug: published_tutorial.slug)
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to_not include("Edit Tutorial")
          expect(response.body).to_not include("Unpublish")
          expect(response.body).to_not include("Publish")
          expect(response.body).to_not include("Drafts")
        end
      end

      context 'when not logged in' do
        it 'responds with show page' do
          do_request(slug: published_tutorial.slug)
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to_not include("Edit Tutorial")
          expect(response.body).to_not include("Unpublish")
          expect(response.body).to_not include("Publish")
          expect(response.body).to_not include("Drafts")
        end
      end
    end

    context 'when tutorial not in published state is requested' do
      context 'when logged in as admin' do
        before { sign_in_as_admin }

        it 'responds with show page' do
          do_request(slug: tutorial.slug)
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to include("Edit Tutorial")
          expect(response.body).to_not include("Unpublish")
          expect(response.body).to include("Publish")
          expect(response.body).to include("Drafts")
        end
      end

      context 'when logged in as editor' do
        before { sign_in_as_editor }

        it 'responds with show page' do
          do_request(slug: tutorial.slug)
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to include("Edit Tutorial")
          expect(response.body).to_not include("Unpublish")
          expect(response.body).to include("Publish")
          expect(response.body).to include("Drafts")
        end
      end

      context 'when logged in as regular user' do
        before { sign_in }

        it 'responds with 404' do
          do_request(slug: tutorial.slug)
          expect(response.status).to eq(404)
        end
      end

      context 'when not logged in' do
        it 'responds with 404' do
          do_request(slug: tutorial.slug)
          expect(response.status).to eq(404)
        end
      end
    end
  end

  describe 'POST like' do
    let!(:user) { create(:user) }

    subject! { create :published_tutorial, score: 2 }

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

      context "when user hasn't already liked the tutorial" do
        it 'upvotes the tutorial and responds with new score' do
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

      context 'when user has already liked the tutorial' do
        let!(:old_like) { create :like, parent: subject, user: user }

        it 'does not re-upvote the tutorial, but responds with current score' do
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

    subject! { create :published_tutorial, score: 2 }

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

      context "when user hasn't already liked the tutorial" do
        it 'does not downvote the tutorial, but responds with current score' do
          expect(subject.score).to eq(2)

          expect {
            do_request
          }.to change(Like, :count).by(0)

          expect(response).to have_http_status :ok
          expect(JSON.parse(response.body)).to eq('score' => 2)
          expect(subject.reload.score).to eq(2)
        end
      end

      context 'when user has already liked the tutorial' do
        let!(:old_like) { create :like, parent: subject, user: user }

        it 'downvotes the tutorial and responds with new score' do
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
