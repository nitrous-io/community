require 'rails_helper'

RSpec.describe BlogsController, type: :controller do

  let!(:blog) { create(:blog) }

  describe "GET #new" do
    context "when logged in" do
      before { session[:admin] = true }
      before { get :new }
      it { expect(response).to render_template(:new) }
      it { expect(response).to have_http_status(:success) }
    end
    context "when not logged in" do
      before { get :new }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "POST #create" do
    context "when logged in as admin, valid params" do
      before { session[:admin] = true }
      before { post :create, blog: attributes_for(:blog) }
      it { expect(response).to redirect_to(blogs_path) }
    end
    context "when logged in as admin, invalid params" do
      before { session[:admin] = true }
      before { post :create, blog: attributes_for(:blog, :invalid) }
      it { expect(response).to render_template(:new) }
    end
    context "when not logged in as admin" do
      before { post :create, blog: attributes_for(:blog) }
      it { expect(response).to redirect_to(root_path) }
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
