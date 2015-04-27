require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET new" do
    context "when user not logged in" do
      before { get :new }
      it { is_expected.to render_template(:new) }
      it { expect(response).to have_http_status(:success) }
    end
    context "when user logged in" do
      before { get :new, session[:user_id] = "1"}
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "POST create" do
    context "with valid params" do
      before { post :create, user: {username_or_email: "bighero", password: "baymaxxy"} }
      it { expect(response).to redirect_to(root_path) }
    end
    context "with invalid params" do
      before { post :create, user: {username_or_email: "fakehero", password: "fakepw"} }
      it { expect(response).to redirect_to(login_path) }
    end
  end

  describe "DELETE destroy" do
    context "with invalid token" do
      before { delete :destroy, session[:token] = "faketoken" }
      it { expect(response).to redirect_to(root_path) }
    end
  end

end
