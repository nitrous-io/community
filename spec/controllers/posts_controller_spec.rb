require 'rails_helper'

describe PostsController do
  describe 'GET #new' do
    render_views

    def do_request
      get :new
    end

    it_behaves_like 'admin new page'
  end

  describe 'GET #edit' do
    subject { create(:post) }
    render_views

    def do_request
      get :edit, id: subject.id
    end

    it_behaves_like 'admin edit page'
  end

  describe 'POST #create' do
    let(:item) { :post }
    let(:model_class) { Post }
    let(:index_path) { posts_path }

    def do_request(params = {})
      post :create, { post: attributes_for(:post) }.merge(params)
    end

    it_behaves_like 'admin create'

    context 'when a user logged in as an admin' do
      before { sign_in_as_admin }

      it 'creates a post' do
        do_request(
            post: {
                title: 'post title',
                content_markdown: 'content markdown',
                tag_list: 'ruby',
                cover_image_url: 'http://example.com/a.jpg'})
        p = Post.last
        expect(p.slug).to eq('post-title')
        expect(p.title).to eq('post title')
        expect(p.cover_image_url).to eq('http://example.com/a.jpg')
        expect(p.content_markdown).to eq('content markdown')
        expect(p.content_html).to match('<p>content markdown</p>')
        expect(p.tag_list).to eq(['ruby'])
      end
    end
  end

  describe 'PUT #update' do
    let(:item) { :post }
    let(:index_path) { posts_path }

    subject { create(:post) }

    def do_request(params = {})
      put :update, { id: subject.id, post: attributes_for(:post) }.merge(params)
    end

    it_behaves_like 'admin update'

    context 'when a user logged in as an admin' do
      before { sign_in_as_admin }

      it 'updates a post' do
        do_request(id: subject.id, post: { title: 'updated post title', content_markdown: 'updated content markdown', tag_list: 'rails' })
        subject.reload
        expect(subject.title).to eq('updated post title')
        expect(subject.content_markdown).to eq('updated content markdown')
        expect(subject.slug).to eq('updated-post-title')
        expect(subject.content_html).to match('<p>updated content markdown</p>')
        expect(subject.tag_list).to eq(['rails'])
        expect(subject.state).to eq('draft')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:index_path) { posts_path }

    subject { create(:post) }

    def do_request(params = {})
      delete :destroy, { id: subject.id }.merge(params)
    end

    it_behaves_like 'admin delete'
  end

  describe 'PUT #unpublish' do
    let(:index_path) { posts_path }

    subject { create(:post) }

    def do_request(params = {})
      put :unpublish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'admin unpublish'
  end

  describe 'GET #index' do
    render_views

    let!(:rust_post)  { create(:post, title: 'rust', tag_list: %w(rust go)) }
    let!(:rails_post) { create(:published_post, published_at: 1.hour.ago,  title: 'rails-post', tag_list: %w(rails ruby)) }
    let!(:go_post)    { create(:published_post, published_at: 2.hours.ago, title: 'go-post',    tag_list: %w(go martini)) }
    let!(:java_post)  { create(:published_post, published_at: 3.hours.ago, title: 'java-post',  tag_list: %w(java      )) }
    let!(:js_post)    { create(:published_post, published_at: 4.hours.ago, title: 'js-post',    tag_list: %w(javascript)) }
    let!(:cgo_post)   { create(:published_post, published_at: 5.hours.ago, title: 'cgo-post',   tag_list: %w(go c      )) }

    def do_request(params = {})
      get :index, params
    end

    it 'renders' do
      do_request
      expect(response).to have_http_status(:success)
    end

    [nil, 1].each do |page|
      context "when page == #{page}" do
        it 'assigns cover_post and posts' do
          do_request(page: page, per_page: 2)
          expect(assigns(:cover_post)).to eq rails_post
          expect(assigns(:posts).map(&:id)).to eq([go_post, java_post].map(&:id))
        end
      end
    end

    context 'when page > 1 is requested' do
      it 'assigns posts, but not cover_post' do
        do_request(page: 2, per_page: 2)
        expect(assigns(:posts).map(&:id)).to eq([js_post, cgo_post].map(&:id))
      end
    end

    context 'tag is specified' do
      it 'assigns posts that have specified tag' do
        do_request(tag: 'go')
        expect(assigns(:posts).map(&:id)).to eq([go_post, cgo_post].map(&:id))
      end
    end
  end

  describe "GET #show" do
    render_views

    let!(:p) { create(:published_post) }

    def do_request
      get :show, slug: p.slug
    end

    it 'renders' do
      do_request
      expect(response).to have_http_status(:success)
    end

    it 'shows upvote button' do
      do_request
      doc = Nokogiri::HTML(response.body)
      selector = "form[action='#{post_likes_path(post_id: p.id)}']"
      expect(doc.css(selector)).not_to be_empty
    end

    context 'a user has upvoted the post' do
      let(:user) { create(:user) }

      before do
        create(:like, parent: p, user: user)
        sign_in(user)
      end

      it 'shows downvote button' do
        do_request
        doc = Nokogiri::HTML(response.body)
        selector = "form[action='#{post_likes_path(post_id: p.id)}'] input[name=_method][value=delete]"
        expect(doc.css(selector)).not_to be_empty
      end
    end

    it_behaves_like 'admin show' do
      let(:item) { p }
    end
  end
end
