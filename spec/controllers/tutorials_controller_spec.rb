require 'rails_helper'

RSpec.describe TutorialsController, type: :controller do

  let!(:tutorial) { create(:tutorial) }

  describe "GET #new" do
    context "when non-admin" do 
      before { get :new }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "POST #create" do
    # FIXME: session["admin"] cannot be set to true. Requires string.
#    context "when admin, invalid tutorial" do
#      before { post :create, tutorial: attributes_for(:tutorial, :invalid), session["admin"] = true }
#      it { is_expected.to render_template(:new) }
#    end
    context "when non-admin" do
      before { post :create }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "GET #index" do
    before { get :index }
    it { expect(response).to render_template(:index) }
    it { expect(response).to be_success }
    render_views
    it { expect(response.body).to include("<h1>content</h1>")}
    it { expect(response.body).to include("haskell")}
    it { expect(response.body).to include("scala")}
  end

  describe "GET #show" do
    context "with valid slug" do
      before { get :show, slug: "this-is-a-slug" }
      it { expect(response).to render_template(:show) }
      it { expect(response).to be_success }
      render_views
      it { expect(response.body).to include("<h1>content</h1>")}
      it { expect(response.body).to include("haskell")}
      it { expect(response.body).to include("scala")}
    end
  end

end
