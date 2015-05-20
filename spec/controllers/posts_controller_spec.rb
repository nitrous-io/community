require 'rails_helper'

describe PostsController do
  describe 'GET #new' do
    render_views

    def do_request
      get :new
    end

    it 'redirects to home page' do
      do_request
      expect(response).to redirect_to(root_path)
    end

    context 'when logged in' do
      before { sign_in }

      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to(root_path)
      end

      context 'when a user is admin' do
        before { sign_in_as_admin }

        it 'renders new template' do
          do_request
          expect(response).to render_template(:new)
        end

        it 'renders successfully' do
          do_request
          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe 'POST #create' do
    def do_request(params = {})
      post :create, { post: attributes_for(:post) }.merge(params)
    end

    it 'redirects to home page' do
      do_request
      expect(response).to redirect_to(root_path)
    end

    context 'when logged in' do
      before { sign_in }

      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to(root_path)
      end

      context 'when a user is admin' do
        before { sign_in_as_admin }

        context 'with valid parameters' do
          it 'creates a post' do
            expect {
              do_request(
                  post: {
                      type:             'blog',
                      title:            'post title',
                      content_markdown: 'content markdown',
                      tag_list:         'ruby'
                  }
              )
            }.to change(Post, :count).by(1)

            p = Post.last
            expect(p.type).to eq('blog')
            expect(p.slug).to eq('post-title')
            expect(p.title).to eq('post title')
            expect(p.content_markdown).to eq('content markdown')
            expect(p.content_html).to match('<p>content markdown</p>')
            expect(p.tag_list).to eq(['ruby'])
          end

          it 'redirects to blog index page' do
            do_request
            expect(response).to redirect_to(posts_path)
          end
        end

        context 'with invalid params' do
          it 'renders new template' do
            expect { do_request(post: attributes_for(:post, :invalid)) }.not_to change(Post, :count)
            expect(response).to render_template(:new)
          end
        end
      end
    end
  end

  describe 'GET #index' do
    render_views

    let!(:rails_blog) { create(:post, type: :blog, tag_list: [:rails, :ruby]) }
    let!(:go_blog) { create(:post, type: :blog, tag_list: [:go, :martini]) }
    let!(:ruby_tutorial) { create(:post, type: :tutorial, tag_list: [:ruby]) }
    let!(:go_tutorial) { create(:post, type: :tutorial, tag_list: [:go]) }

    def do_request(params = {})
      get :index, params
    end

    it 'renders' do
      do_request
      expect(response).to have_http_status(:success)
    end

    it 'assigns blogs' do
      do_request
      expect(assigns(:posts)).to contain_exactly(rails_blog, go_blog)
    end

    context 'type is blog' do
      it 'assigns blogs' do
        do_request(type: :blog)
        expect(assigns(:posts)).to contain_exactly(rails_blog, go_blog)
      end

      context 'tag is specified' do
        it 'assigns blogs that have specified tag' do
          do_request(type: :blog, tag: 'go')
          expect(assigns(:posts)).to contain_exactly(go_blog)
        end
      end
    end

    context 'type is tutorial' do
      it 'assigns tutorials' do
        do_request(type: :tutorial)
        expect(assigns(:posts)).to contain_exactly(ruby_tutorial, go_tutorial)
      end

      context 'tag is specified' do
        it 'assigns tutorials that have specified tag' do
          do_request(type: :tutorial, tag: 'ruby')
          expect(assigns(:posts)).to contain_exactly(ruby_tutorial)
        end
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
