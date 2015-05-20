require 'rails_helper'

RSpec.describe BlogsController, type: :controller do

  let!(:blog) { create(:blog) }

  describe "GET #new" do
    def do_request
      get :new
    end

    context "when logged in" do
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

    context "when not logged in" do
      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST #create" do
    def do_request(params = {})
      post :create, { blog: attributes_for(:blog) }.merge(params)
    end

    context 'when a user is admin' do
      before { sign_in_as_admin }

      context 'with valid parameters' do
        it 'redirects to blog index page' do
          do_request
          expect(response).to redirect_to(blogs_path)
        end
      end

      context 'with invalid params' do
        it 'renders new template' do
          do_request(blog: attributes_for(:blog, :invalid))
          expect(response).to render_template(:new)
        end
      end
    end

    it 'redirects to home page' do
      do_request
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #index" do
    before { get :index }
    it { expect(response).to render_template(:index) }
    it { expect(response).to have_http_status(:success) }
  end

  describe "GET #show" do
    context "with valid slug" do
      before { get :show, slug: "this-is-a-slug" }
      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(:success) }
      render_views
      it { expect(response.body).to include("content html")}
      it { expect(response.body).to include("ruby")}
    end
  end

end
