require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let!(:tutorial) { create(:tutorial) }

  describe "POST #create" do
    context "when user is logged in" do
      before { sign_in }
      before { post :create, tutorial_id: tutorial.id, slug: "a-slug", comment: attributes_for(:comment) }

      # TODO: Refactor when replaced by AJAX.
      it { expect(response).to redirect_to(tutorial_path("a-slug")) }
    end
    context "when user is not logged in" do
      before { post :create }
      it { expect(response).to redirect_to(login_path) }
    end
  end

end
