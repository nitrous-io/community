require 'rails_helper'

describe DraftsController do
  describe 'GET index' do
    render_views

    def do_request
      get :index
    end

    context 'when the user is not an admin' do
      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to root_path
      end
    end

    context 'when the user is an admin' do
      before { sign_in_as_admin }

      it 'redirects to drafts/tutorials path' do
        do_request
        expect(response).to redirect_to tutorials_drafts_path
      end
    end
  end

  describe 'GET posts' do
    render_views

    def do_request(params={})
      get :posts, params
    end

    context 'when the user is not an admin' do
      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to root_path
      end
    end

    context 'when the user is an admin' do
      before { sign_in_as_admin }

      let!(:draft_post1) { create(:post) }
      let!(:draft_post2) { create(:post) }
      let!(:draft_post3) { create(:post) }
      let!(:published_post1) { create(:published_post) }
      let!(:published_post2) { create(:published_post) }
      let!(:published_post3) { create(:published_post) }

      it 'assigns draft posts' do
        do_request
        expect(response).to have_http_status :ok
        expect(assigns(:posts)).to contain_exactly(draft_post3, draft_post2, draft_post1)
      end

      context 'with pagination' do
        [nil, 1].each do |page|
          context "when page #{page} is requested" do
            it 'assigns drafts in page 1' do
              do_request(page: page, per_page: 2)
              expect(response).to have_http_status :ok
              expect(assigns(:posts)).to contain_exactly(draft_post3, draft_post2)
            end
          end
        end

        context "when page > 1 is requested" do
          it 'assigns drafts in page 2' do
            do_request(page: 2, per_page: 2)
            expect(response).to have_http_status :ok
            expect(assigns(:posts)).to contain_exactly(draft_post1)
          end
        end
      end
    end
  end

  describe 'GET tutorials' do
    render_views

    def do_request(params={})
      get :tutorials, params
    end

    context 'when the user is not an admin' do
      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to root_path
      end
    end

    context 'when the user is an admin' do
      before { sign_in_as_admin }

      let!(:draft_tutorial1) { create(:tutorial) }
      let!(:draft_tutorial2) { create(:tutorial) }
      let!(:draft_tutorial3) { create(:tutorial) }
      let!(:published_tutorial1) { create(:published_tutorial) }
      let!(:published_tutorial2) { create(:published_tutorial) }
      let!(:published_tutorial3) { create(:published_tutorial) }

      it 'shows draft tutorials' do
        do_request
        expect(response).to have_http_status :ok
        expect(assigns(:tutorials)).to contain_exactly(draft_tutorial3, draft_tutorial2, draft_tutorial1)
      end

      context 'with pagination' do
        [nil, 1].each do |page|
          context "when page #{page} is requested" do
            it 'assigns drafts in page 1' do
              do_request(page: page, per_page: 2)
              expect(response).to have_http_status :ok
              expect(assigns(:tutorials)).to contain_exactly(draft_tutorial3, draft_tutorial2)
            end
          end
        end

        context "when page > 1 is requested" do
          it 'assigns drafts in page 2' do
            do_request(page: 2, per_page: 2)
            expect(response).to have_http_status :ok
            expect(assigns(:tutorials)).to contain_exactly(draft_tutorial1)
          end
        end
      end
    end
  end
end
