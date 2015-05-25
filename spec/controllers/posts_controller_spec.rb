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
        do_request(post: { type: 'post', title: 'post title', content_markdown: 'content markdown', tag_list: 'ruby' })
        p = Post.last
        expect(p.type).to eq('post')
        expect(p.slug).to eq('post-title')
        expect(p.title).to eq('post title')
        expect(p.content_markdown).to eq('content markdown')
        expect(p.content_html).to match('<p>content markdown</p>')
        expect(p.tag_list).to eq(['ruby'])
      end
    end
  end

  describe 'GET #index' do
    render_views

    let!(:rails_post) { create(:post, tag_list: [:rails, :ruby]) }
    let!(:go_post) { create(:post, tag_list: [:go, :martini]) }

    def do_request(params = {})
      get :index, params
    end

    it 'renders' do
      do_request
      expect(response).to have_http_status(:success)
    end

    it 'assigns posts' do
      do_request(type: :post)
      expect(assigns(:posts)).to contain_exactly(rails_post, go_post)
    end

    context 'tag is specified' do
      it 'assigns posts that have specified tag' do
        do_request(type: :post, tag: 'go')
        expect(assigns(:posts)).to contain_exactly(go_post)
      end
    end
  end

  describe "GET #show" do
    render_views

    let!(:p) { create(:post) }
    before { get :show, slug: p.slug }
    it { expect(response).to have_http_status(:success) }
  end
end
