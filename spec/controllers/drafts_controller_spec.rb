require 'rails_helper'

describe DraftsController do
  describe 'GET index' do
    render_views

    def do_request
      get :index
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'redirects to drafts/tutorials path' do
        do_request
        expect(response).to redirect_to(tutorials_drafts_path)
      end
    end
  end

  describe 'GET posts' do
    render_views

    def do_request(params={})
      get :posts, params
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      let!(:draft_post1)     { create(:post, updated_at: 3.hours.ago ) }
      let!(:draft_post2)     { create(:post, updated_at: 2.hours.ago ) }
      let!(:draft_post3)     { create(:post, updated_at: 1.hour.ago ) }
      let!(:published_post1) { create(:published_post, updated_at: 3.hours.ago ) }
      let!(:published_post2) { create(:published_post, updated_at: 2.hours.ago ) }
      let!(:published_post3) { create(:published_post, updated_at: 1.hour.ago ) }

      it 'assigns draft posts' do
        do_request
        expect(response).to have_http_status :ok
        expect(assigns(:posts).map(&:id)).to eq([draft_post3, draft_post2, draft_post1].map(&:id))
      end

      context 'with pagination' do
        [nil, 1].each do |page|
          context "when page #{page} is requested" do
            it 'assigns drafts in page 1' do
              do_request(page: page, per_page: 2)
              expect(response).to have_http_status :ok
              expect(assigns(:posts).map(&:id)).to eq([draft_post3, draft_post2].map(&:id))
            end
          end
        end

        context "when page > 1 is requested" do
          it 'assigns drafts in page 2' do
            do_request(page: 2, per_page: 2)
            expect(response).to have_http_status :ok
            expect(assigns(:posts).map(&:id)).to eq([draft_post1].map(&:id))
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

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      let!(:draft_tutorial1) { create(:tutorial, updated_at: 3.hours.ago ) }
      let!(:draft_tutorial2) { create(:tutorial, updated_at: 2.hours.ago ) }
      let!(:draft_tutorial3) { create(:tutorial, updated_at: 1.hour.ago ) }
      let!(:published_tutorial1) { create(:published_tutorial, updated_at: 3.hours.ago ) }
      let!(:published_tutorial2) { create(:published_tutorial, updated_at: 2.hours.ago ) }
      let!(:published_tutorial3) { create(:published_tutorial, updated_at: 1.hour.ago ) }

      it 'shows draft tutorials' do
        do_request
        expect(response).to have_http_status :ok
        expect(assigns(:tutorials).map(&:id)).to eq([draft_tutorial3, draft_tutorial2, draft_tutorial1].map(&:id))
      end

      context 'with pagination' do
        [nil, 1].each do |page|
          context "when page #{page} is requested" do
            it 'assigns drafts in page 1' do
              do_request(page: page, per_page: 2)
              expect(response).to have_http_status :ok
              expect(assigns(:tutorials).map(&:id)).to eq([draft_tutorial3, draft_tutorial2].map(&:id))
            end
          end
        end

        context "when page > 1 is requested" do
          it 'assigns drafts in page 2' do
            do_request(page: 2, per_page: 2)
            expect(response).to have_http_status :ok
            expect(assigns(:tutorials).map(&:id)).to eq([draft_tutorial1].map(&:id))
          end
        end
      end
    end
  end

  describe 'GET docs' do
    render_views

    def do_request(params={})
      get :docs, params
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      let!(:draft_doc1) { create(:doc, updated_at: 3.hours.ago ) }
      let!(:draft_doc2) { create(:doc, updated_at: 2.hours.ago ) }
      let!(:draft_doc3) { create(:doc, updated_at: 1.hour.ago ) }
      let!(:published_doc1) { create(:published_doc, updated_at: 3.hours.ago ) }
      let!(:published_doc2) { create(:published_doc, updated_at: 2.hours.ago ) }
      let!(:published_doc3) { create(:published_doc, updated_at: 1.hour.ago ) }

      it 'shows draft docs' do
        do_request
        expect(response).to have_http_status :ok
        expect(assigns(:docs).map(&:id)).to eq([draft_doc3, draft_doc2, draft_doc1].map(&:id))
      end

      context 'with pagination' do
        [nil, 1].each do |page|
          context "when page #{page} is requested" do
            it 'assigns drafts in page 1' do
              do_request(page: page, per_page: 2)
              expect(response).to have_http_status :ok
              expect(assigns(:docs).map(&:id)).to eq([draft_doc3, draft_doc2].map(&:id))
            end
          end
        end

        context "when page > 1 is requested" do
          it 'assigns drafts in page 2' do
            do_request(page: 2, per_page: 2)
            expect(response).to have_http_status :ok
            expect(assigns(:docs).map(&:id)).to eq([draft_doc1].map(&:id))
          end
        end
      end
    end
  end
end
