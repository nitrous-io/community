require 'rails_helper'

describe DraftsController do
  describe 'GET #index' do
    render_views

    def do_request
      get :index
    end

    it 'redirects to home page if a user is not admin' do
      do_request
      expect(response).to redirect_to root_path
    end

    context 'a user is admin' do
      before { sign_in_as_admin }

      let!(:draft_post) { create(:post) }
      let!(:published_post) { create(:published_post) }
      let!(:draft_tutorial) { create(:tutorial) }
      let!(:published_tutorial) { create(:published_tutorial) }

      it 'renders drafts' do
        do_request
        expect(response).to be_success
        expect(assigns(:posts)).to contain_exactly(draft_post)
        expect(assigns(:tutorials)).to contain_exactly(draft_tutorial)
      end
    end
  end

  describe 'GET #posts' do
    render_views

    def do_request(params = {})
      get :posts, params.merge(format: :js)
    end

    it 'redirects to home page if a user is not admin' do
      do_request
      expect(response).to redirect_to root_path
    end

    context 'a user is admin' do
      before { sign_in_as_admin }

      let!(:draft_go_post) { create(:post) }
      let!(:draft_rails_post) { create(:post) }

      it 'renders drafts' do
        do_request
        expect(response).to be_success
        expect(assigns(:posts)).to contain_exactly(draft_go_post, draft_rails_post)
      end

      context 'with pagination' do
        before do
          Timecop.freeze(2.days.ago) { draft_rails_post.update_attribute(:title, 'new post title') }
        end

        specify do
          do_request(per_page: 1, page: 1)
          expect(assigns(:posts)).to contain_exactly(draft_go_post)
        end

        context 'not first page' do
          specify do
            do_request(per_page: 1, page: 2)
            expect(response).to render_template('posts/_list')
            expect(response.body).to match(edit_post_path(draft_rails_post.id))
          end
        end
      end
    end
  end

  describe 'GET #tutorials' do
    render_views

    def do_request(params = {})
      get :tutorials, params.merge(format: :js)
    end

    it 'redirects to home page if a user is not admin' do
      do_request
      expect(response).to redirect_to root_path
    end

    context 'a user is admin' do
      before { sign_in_as_admin }

      let!(:draft_go_tutorial) { create(:tutorial) }
      let!(:draft_rails_tutorial) { create(:tutorial) }

      it 'renders drafts' do
        do_request
        expect(response).to be_success
        expect(assigns(:tutorials)).to contain_exactly(draft_go_tutorial, draft_rails_tutorial)
      end

      context 'with pagination' do
        before do
          Timecop.freeze(2.days.ago) { draft_rails_tutorial.update_attribute(:title, 'new post title') }
        end

        specify do
          do_request(per_page: 1, page: 1)
          expect(assigns(:tutorials)).to contain_exactly(draft_go_tutorial)
        end

        context 'not first page' do
          specify do
            do_request(per_page: 1, page: 2)
            expect(response).to render_template('tutorials/_list')
            expect(response.body).to match(edit_tutorial_path(draft_rails_tutorial.id))
          end
        end
      end
    end
  end
end
