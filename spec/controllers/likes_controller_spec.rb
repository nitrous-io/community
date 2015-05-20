require 'rails_helper'

RSpec.describe LikesController, type: :controller do

  let!(:p) { create(:post) }
  let!(:like) { create(:like) }

  describe "POST #create" do
    context "when logged in, user has not voted before" do
      before { sign_in }

      def do_request
        post :create, post_id: p.id, slug: "a-slug", like: attributes_for(:like)
      end

      #TODO: Change test result when refactor to use AJAX.
      it do
        do_request
        expect(response).to redirect_to(posts_slugged_path(slug: "a-slug"))
      end

      it do
        expect { do_request }.to change { p.reload.score }.from(0).to(1)
      end
    end
    context "when logged in, user has voted before" do
      before { sign_in }
      before { post :create, post_id: p.id, slug: "a-slug", like: attributes_for(:like) }
      #TODO: Change test result when refactor to use AJAX.
      it { expect(response).to redirect_to(posts_slugged_path(slug: "a-slug")) }
    end
    context "when not logged in" do
      before { post :create }
      it { expect(response).to redirect_to(login_path) }
    end
  end

end
