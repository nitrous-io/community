require 'rails_helper'

RSpec.describe TutorialsController, type: :controller do
  let (:tutorial) { create(:tutorial) }

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
      before { post :create, tutorial: attributes_for(:tutorial) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

end
