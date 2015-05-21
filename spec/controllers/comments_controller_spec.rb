require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let!(:p) { create(:post) }
  let!(:user) { create(:user) }

  describe 'POST #create' do
    def do_request
      post :create, post_id: p.id, comment: { content: 'hello' }
    end

    context 'when user is logged in' do
      before { sign_in(user) }


      it 'redirects to the post page' do
        do_request
        expect(response).to redirect_to(posts_slugged_path(slug: p.slug))
      end

      it 'create a comment' do
        expect { do_request }.to change(Comment, :count).by(1)
        comment = Comment.last
        expect(comment.post_id).to eq(p.id)
        expect(comment.user_id).to eq(user.id)
        expect(comment.content).to eq('hello')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        do_request
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
