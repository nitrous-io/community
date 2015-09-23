require 'rails_helper'

describe PostsController do
  render_views

  describe 'GET new' do
    def do_request
      get :new
    end

    it_behaves_like 'an admin or editor only action'

    context 'when logged in as admin' do
      before { sign_in_as_admin }

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
      post :create, { post: attributes_for(:post) }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_editor }

      it 'creates a post' do
        do_request(post: {
          title: 'post title',
          content_markdown: '# content markdown',
          tag_list: 'ruby',
          cover_image_url: 'http://example.com/a.jpg'
        })

        o = Post.last

        expect(response).to redirect_to(post_path(o))
        expect(o.slug).to eq('post-title')
        expect(o.title).to eq('post title')
        expect(o.cover_image_url).to eq('http://example.com/a.jpg')
        expect(o.content_markdown).to eq('# content markdown')
        expect(o.content_html).to match('<h1>content markdown</h1>')
        expect(o.content_text).to match('content markdown')
        expect(o.tag_list).to eq(['ruby'])
      end
    end

    context 'when user is logged in as editor' do
      before { sign_in_as_editor }

      it 'creates a post' do
        do_request(post: {
          title: 'post title',
          content_markdown: '# content markdown',
          tag_list: 'ruby',
          cover_image_url: 'http://example.com/a.jpg'
        })

        o = Post.last

        expect(response).to redirect_to(post_path(o))
        expect(o.slug).to eq('post-title')
        expect(o.title).to eq('post title')
        expect(o.cover_image_url).to eq('http://example.com/a.jpg')
        expect(o.content_markdown).to eq('# content markdown')
        expect(o.content_html).to match('<h1>content markdown</h1>')
        expect(o.content_text).to match('content markdown')
        expect(o.tag_list).to eq(['ruby'])
      end
    end
  end

  describe 'GET edit' do
    subject { create :post }

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
    subject! { create :post }

    def do_request(params = {})
      put :update, { id: subject.id, post: attributes_for(:post) }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_admin }

      it 'updates the post' do
        do_request(id: subject.id, post: {
          title: 'updated post title',
          content_markdown: '# updated content markdown',
          tag_list: 'rails'
        })

        subject.reload

        expect(response).to redirect_to(post_path(subject))
        expect(subject.title).to eq('updated post title')
        expect(subject.slug).to eq('updated-post-title')
        expect(subject.content_markdown).to eq('# updated content markdown')
        expect(subject.content_html).to match('<h1>updated content markdown</h1>')
        expect(subject.content_text).to match('updated content markdown')
        expect(subject.tag_list).to eq(['rails'])
      end

      context 'when publish param is true' do
        it 'updates the post and publishes the post' do
          now = nil

          Timecop.freeze do
            now = Time.now

            do_request(id: subject.id, post: {
              title: 'updated post title',
              content_markdown: '# updated content markdown',
              tag_list: 'rails'
            }, publish: 'true')
          end

          subject.reload

          expect(response).to redirect_to(post_path(subject))
          expect(subject.title).to eq('updated post title')
          expect(subject.slug).to eq('updated-post-title')
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

      it 'updates the post' do
        do_request(id: subject.id, post: {
          title: 'updated post title',
          content_markdown: '# updated content markdown',
          tag_list: 'rails'
        })

        subject.reload

        expect(response).to redirect_to(post_path(subject))
        expect(subject.title).to eq('updated post title')
        expect(subject.slug).to eq('updated-post-title')
        expect(subject.content_markdown).to eq('# updated content markdown')
        expect(subject.content_html).to match('<h1>updated content markdown</h1>')
        expect(subject.content_text).to match('updated content markdown')
        expect(subject.tag_list).to eq(['rails'])
      end

      context 'when publish param is true' do
        it 'updates the post and publishes the post' do
          now = nil

          Timecop.freeze do
            now = Time.now

            do_request(id: subject.id, post: {
              title: 'updated post title',
              content_markdown: '# updated content markdown',
              tag_list: 'rails'
            }, publish: 'true')
          end

          subject.reload

          expect(response).to redirect_to(post_path(subject))
          expect(subject.title).to eq('updated post title')
          expect(subject.slug).to eq('updated-post-title')
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
    subject! { create :post }

    def do_request(params = {})
      delete :destroy, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_admin }

      it 'deletes the post' do
        expect {
          do_request
        }.to change{ subject.reload.deleted? }.from(false).to(true)

        expect(response).to redirect_to(posts_path)
      end
    end

    context 'when user is logged in as editor' do
      before { sign_in_as_editor }

      it 'deletes the post' do
        expect {
          do_request
        }.to change{ subject.reload.deleted? }.from(false).to(true)

        expect(response).to redirect_to(posts_path)
      end
    end
  end

  describe 'POST publish' do
    subject! { create :post }

    def do_request(params = {})
      post :publish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_admin }

      it 'publishes the post' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(false).to(true)

          expect(subject.published_at.to_i).to eq(Time.now.to_i)
        end

        expect(response).to redirect_to(post_path(subject))
      end
    end

    context 'when user is logged in as editor' do
      before { sign_in_as_editor }

      it 'publishes the post' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(false).to(true)

          expect(subject.published_at.to_i).to eq(Time.now.to_i)
        end

        expect(response).to redirect_to(post_path(subject))
      end
    end
  end

  describe 'POST unpublish' do
    subject! { create :post }
    before { subject.published! }

    def do_request(params = {})
      post :unpublish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin or editor only action'

    context 'when user is logged in as admin' do
      before { sign_in_as_admin }

      it 'unpublishes the post' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(true).to(false)

          expect(subject.published_at).to be_nil
        end

        expect(response).to redirect_to(post_path(subject))
      end
    end

    context 'when user is logged in as editor' do
      before { sign_in_as_editor }

      it 'unpublishes the post' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(true).to(false)

          expect(subject.published_at).to be_nil
        end

        expect(response).to redirect_to(post_path(subject))
      end
    end
  end

  describe 'GET index' do
    let!(:rust_post)  { create(:post, title: 'rust', tag_list: %w(rust go)) }
    let!(:rails_post) { create(:published_post, published_at: 1.hour.ago,  title: 'rails-post', tag_list: %w(rails ruby)) }
    let!(:go_post)    { create(:published_post, published_at: 2.hours.ago, title: 'go-post',    tag_list: %w(go martini)) }
    let!(:java_post)  { create(:published_post, published_at: 3.hours.ago, title: 'java-post',  tag_list: %w(java      )) }
    let!(:js_post)    { create(:published_post, published_at: 4.hours.ago, title: 'js-post',    tag_list: %w(javascript)) }
    let!(:cgo_post)   { create(:published_post, published_at: 5.hours.ago, title: 'cgo-post',   tag_list: %w(go c      )) }

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
        it 'assigns cover_content and content' do
          do_request(page: page, per_page: 2)
          expect(assigns(:cover_content)).to eq rails_post
          expect(assigns(:content).map(&:id)).to eq([go_post, java_post].map(&:id))
        end
      end
    end

    context 'when page > 1 is requested' do
      it 'assigns content, but not cover_content' do
        do_request(page: 2, per_page: 2)
        expect(assigns(:content).map(&:id)).to eq([js_post, cgo_post].map(&:id))
        expect(assigns(:cover_content)).to be_blank
      end
    end

    context 'tag is specified' do
      it 'assigns content that have specified tag' do
        do_request(tag: 'go')
        expect(assigns(:content).map(&:id)).to eq([go_post, cgo_post].map(&:id))
        expect(assigns(:cover_content)).to be_blank
      end
    end
  end

  describe "GET show" do
    subject { create :published_post }

    def do_request
      get :show, slug: subject.slug
    end

    context 'when logged in as admin' do
      before { sign_in_as_admin }

        it 'responds with show page' do
          do_request
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to include("Edit Blog Post")
          expect(response.body).to_not include("Publish")
          expect(response.body).to include("Unpublish")
          expect(response.body).to include("Drafts")
        end
    end

    context 'when logged in as editor' do
      before { sign_in_as_editor }

        it 'responds with show page' do
          do_request
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to include("Edit Blog Post")
          expect(response.body).to_not include("Publish")
          expect(response.body).to include("Unpublish")
          expect(response.body).to include("Drafts")
        end
    end

    context 'when logged in as regular user' do
      before { sign_in }

        it 'responds with show page' do
          do_request
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to_not include("Edit Blog Post")
          expect(response.body).to_not include("Publish")
          expect(response.body).to_not include("Unpublish")
          expect(response.body).to_not include("Drafts")
        end
    end

    context 'when not logged in' do
      before { sign_in }

        it 'responds with show page' do
          do_request
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:show)

          expect(response.body).to_not include("Edit Blog Post")
          expect(response.body).to_not include("Publish")
          expect(response.body).to_not include("Unpublish")
          expect(response.body).to_not include("Drafts")
        end
    end

  end

  describe 'POST like' do
    let!(:user) { create(:user) }

    subject! { create :published_post, score: 2 }

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

      context "when user hasn't already liked the post" do
        it 'upvotes the post and responds with new score' do
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

      context 'when user has already liked the post' do
        let!(:old_like) { create :like, parent: subject, user: user }

        it 'does not re-upvote the post, but responds with current score' do
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

    subject! { create :published_post, score: 2 }

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

      context "when user hasn't already liked the post" do
        it 'does not downvote the post, but responds with current score' do
          expect(subject.score).to eq(2)

          expect {
            do_request
          }.to change(Like, :count).by(0)

          expect(response).to have_http_status :ok
          expect(JSON.parse(response.body)).to eq('score' => 2)
          expect(subject.reload.score).to eq(2)
        end
      end

      context 'when user has already liked the post' do
        let!(:old_like) { create :like, parent: subject, user: user }

        it 'downvotes the post and responds with new score' do
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
