require 'rails_helper'

RSpec.describe BlogsController, type: :controller do

  let!(:blog) { create(:blog) }

  describe "GET #new" do
    context "when logged in" do
      before { get :new, session[:user_id] = "1" }
      it { expect(response).to have_http_status(:success) }
    end
    context "when not logged in" do
      before { get :new, session[:user_id] = nil }
      it { expect(response).to redirect_to(login_path) }
    end
  end

  describe "POST #create" do
    #before { post :create, session[:user_id] = "1" }
    #it { expect(response).to have_http_status(:success) }
    context "when not logged in" do
      before { post :create }
      it { expect(response).to redirect_to(login_path) }
    end

  end

  describe "GET #index" do
    before { get :index }
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
