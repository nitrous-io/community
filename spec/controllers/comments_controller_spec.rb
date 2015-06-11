require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let!(:p) { create(:post) }
  let!(:user) { create(:user) }

  describe 'POST #create' do
    render_views
    def do_request(params = {})
      post :create, { post_id: p.id, comment: { content_markdown: 'hello' } }.merge(params)
    end

    context 'when user is logged in' do
      before { sign_in(user) }

      it 'redirects to the post page' do
        do_request
        expect(response).to render_template('partials/_comments_with_form')
        expect(response.body).to match(post_comments_path(p.id))
      end

      it 'create a comment' do
        expect { do_request }.to change(Comment, :count).by(1)
        comment = Comment.last
        expect(comment.parent).to eq(p)
        expect(comment.user_id).to eq(user.id)
        expect(comment.content_markdown).to eq('hello')
        expect(comment.content_html).to eq("<p>hello</p>\n")
        expect(comment.content_text).to eq('hello')
      end

      context 'parent is tutorial' do
        let!(:tutorial) { create(:tutorial) }

        it 'redirects to the post page' do
          do_request(tutorial_id: tutorial.id, post_id: nil)
          expect(response).to render_template('partials/_comments_with_form')
          expect(response.body).to match(tutorial_comments_path(tutorial.id))
        end

        it 'create a comment on the tutorial' do
          expect { do_request(tutorial_id: tutorial.id, post_id: nil) }.to change(Comment, :count).by(1)
          comment = Comment.last
          expect(comment.parent).to eq(tutorial)
          expect(comment.user_id).to eq(user.id)
          expect(comment.content_markdown).to eq('hello')
          expect(comment.content_html).to eq("<p>hello</p>\n")
          expect(comment.content_text).to eq('hello')
        end
      end
    end

    context 'when user is not logged in' do
      let(:referrer) { 'http://example.com/posts/1' }
      before { request.env['HTTP_REFERER'] = 'http://example.com/posts/1' }

      it 'redirects to login page' do
        do_request
        expect(response).to redirect_to(login_path(return_to: referrer))
      end

      it 'keeps form values in session' do
        do_request
        expect(session[:comment][:parent_id]).to(eq(p.id))
        expect(session[:comment][:parent_type]).to(eq('Post'))
        expect(session[:comment][:content_markdown]).to(eq('hello'))
      end
    end
  end
end
