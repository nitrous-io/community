require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let!(:p) { create(:post) }
  let!(:user) { create(:user) }

  describe "POST #create" do
    def do_request(params = {})
      xhr :post, :create, { post_id: p.id }.merge(params)
    end

    context 'when logged in' do
      render_views
      before { sign_in(user) }

      context 'user has not voted before' do
        it 'redirects to the post page' do
          do_request
          expect(response).to render_template('partials/_heart')
        end

        it 'upvotes the post' do
          expect {
            expect {
              do_request
            }.to change { p.reload.score }.by(1)
          }.to change(Like, :count).by(1)

          like = Like.last
          expect(like.parent).to(eq(p))
          expect(like.user).to(eq(user))
        end

        context 'on tutorials' do
          let(:tutorial) { create(:tutorial) }

          it 'redirects to the post page' do
            do_request(tutorial_id: tutorial.id, post_id: nil)
            expect(response).to render_template('partials/_heart')
          end

          it 'upvotes the tutorial' do
            expect {
              expect {
                do_request(tutorial_id: tutorial.id, post_id: nil)
              }.to change { tutorial.reload.score }.by(1)
            }.to change(Like, :count).by(1)

            like = Like.last
            expect(like.parent).to(eq(tutorial))
            expect(like.user).to(eq(user))
          end
        end
      end

      context 'user has voted before' do
        before do
          create(:like, user: user, parent: p)
        end

        it 'redirects to the post page' do
          do_request
          expect(response).to render_template('partials/_heart')
        end

        it 'does not upvote the post' do
          expect {
            expect {
              do_request
            }.not_to change { p.reload.score }
          }.not_to change(Like, :count)
        end

        context 'on tutorials' do
          let(:tutorial) { create(:tutorial) }

          before do
            create(:like, user: user, parent: tutorial)
          end

          it 'redirects to the tutorial page' do
            do_request(tutorial_id: tutorial.id, post_id: nil)
            expect(response).to render_template('partials/_heart')
          end

          it 'does not upvote the tutorial' do
            expect {
              expect {
                do_request(tutorial_id: tutorial.id, post_id: nil)
              }.not_to change { tutorial.reload.score }
            }.not_to change(Like, :count)
          end
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to login page' do
        do_request
        expect(response).to render_template('partials/_login_error')
      end

      it 'does not upvote the post' do
        expect {
          expect {
            do_request
          }.not_to change { p.reload.score }
        }.not_to change(Like, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    def do_request(params = {})
      xhr :post, :destroy, { post_id: p.id }.merge(params)
    end

    context 'when logged in' do
      render_views
      before { sign_in(user) }

      context 'user has voted' do
        let!(:like) { create(:like, user: user, parent: p) }

        it 'redirects to the post page' do
          do_request
          expect(response).to render_template('partials/_heart')
        end

        it 'upvotes the post' do
          expect {
            expect {
              do_request
            }.to change { p.reload.score }.by(-1)
          }.to change(Like, :count).by(-1)
        end

        context 'on tutorials' do
          let(:tutorial) { create(:tutorial) }
          let!(:like) { create(:like, user: user, parent: tutorial) }

          it 'redirects to the post page' do
            do_request(tutorial_id: tutorial.id, post_id: nil)
            expect(response).to render_template('partials/_heart')
          end

          it 'upvotes the tutorial' do
            expect {
              expect {
                do_request(tutorial_id: tutorial.id, post_id: nil)
              }.to change { tutorial.reload.score }.by(-1)
            }.to change(Like, :count).by(-1)
          end
        end
      end

      context 'user has not voted before' do
        it 'redirects to the post page' do
          do_request
          expect(response).to render_template('partials/_heart')
        end

        it 'does not upvote the post' do
          expect {
            expect {
              do_request
            }.not_to change { p.reload.score }
          }.not_to change(Like, :count)
        end

        context 'on tutorials' do
          let(:tutorial) { create(:tutorial) }

          it 'redirects to the tutorial page' do
            do_request(tutorial_id: tutorial.id, post_id: nil)
            expect(response).to render_template('partials/_heart')
          end

          it 'does not upvote the tutorial' do
            expect {
              expect {
                do_request(tutorial_id: tutorial.id, post_id: nil)
              }.not_to change { tutorial.reload.score }
            }.not_to change(Like, :count)
          end
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to login page' do
        do_request
        expect(response).to render_template('partials/_login_error')
      end

      it 'does not upvote the post' do
        expect {
          expect {
            do_request
          }.not_to change { p.reload.score }
        }.not_to change(Like, :count)
      end
    end
  end
end
