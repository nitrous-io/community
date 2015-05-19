require 'rails_helper'

RSpec.describe LikesController, type: :controller do

  let!(:tutorial) { create(:tutorial) }
  let!(:like ) { create(:like) }

  describe "POST #create" do
    context "when logged in, user has not voted before" do
      before do
        session[:user_id] = 2
      end

      def do_request
        post :create, tutorial_id: tutorial.id, slug: "a-slug", like: attributes_for(:like)
      end

      #TODO: Change test result when refactor to use AJAX.
      it do
        do_request
        expect(response).to redirect_to(tutorial_path("a-slug"))
      end

      it do
        expect { do_request }.to change { tutorial.reload.score }.from(0).to(1)
      end
    end
    context "when logged in, user has voted before" do
      before { session[:user_id] = 1 }
      before { post :create, tutorial_id: 1, slug: "a-slug", like: attributes_for(:like) }
      #TODO: Change test result when refactor to use AJAX.
      it { expect(response).to redirect_to(tutorial_path("a-slug")) }
    end
    context "when not logged in" do
      before { post :create }
      it { expect(response).to redirect_to(login_path) }
    end
  end

end
