require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:o) { create(:post) }
  let!(:user) { create(:user) }

  describe 'POST #create' do
    def do_request(params = {})
      post :create, { post_id: o.id, comment: { content: 'hello' } }.merge(params)
    end

    context 'when user is logged in' do
      before { sign_in(user) }

      it 'redirects to the post page' do
        do_request
        comment = Comment.last
        expect(response).to redirect_to(posts_slugged_path(slug: o.slug, anchor: "comment-#{comment.id}"))
      end

      it 'create a comment' do
        expect { do_request }.to change(Comment, :count).by(1)
        comment = Comment.last
        expect(comment.parent).to eq(o)
        expect(comment.user_id).to eq(user.id)
        expect(comment.content).to eq('hello')
      end

      context 'parent is tutorial' do
        let!(:tutorial) { create(:tutorial) }

        it 'redirects to the post page' do
          do_request(tutorial_id: tutorial.id, post_id: nil)
          comment = Comment.last
          expect(response).to redirect_to(tutorials_slugged_path(slug: tutorial.slug, anchor: "comment-#{comment.id}"))
        end

        it 'create a comment on the tutorial' do
          expect { do_request(tutorial_id: tutorial.id, post_id: nil) }.to change(Comment, :count).by(1)
          comment = Comment.last
          expect(comment.parent).to eq(tutorial)
          expect(comment.user_id).to eq(user.id)
          expect(comment.content).to eq('hello')
        end
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
