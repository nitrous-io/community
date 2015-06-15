require 'rails_helper'

describe SearchController do
  render_views

  let!(:rails_post)     { create(:published_post, published_at: 6.hours.ago, title: 'ruby on rails') }
  let!(:ruby_post)      { create(:published_post, published_at: 5.hours.ago, title: 'ruby development') }
  let!(:go_post)        { create(:published_post, published_at: 4.hours.ago, title: 'go') }
  let!(:js_post)        { create(:post,           published_at: 3.hours.ago, title: 'js with ruby') }
  let!(:groovy_post)    { create(:published_post, published_at: 2.hours.ago, title: 'groovy', content_markdown: 'groovy is similar to ruby') }
  let!(:rake_post)      { create(:published_post, published_at: 1.hour.ago,  title: 'ruby-rake') }

  let!(:rails_tutorial)  { create(:published_tutorial, published_at: 6.hours.ago, title: 'ruby on rails') }
  let!(:go_tutorial)     { create(:published_tutorial, published_at: 5.hours.ago, title: 'go') }
  let!(:ruby_tutorial)   { create(:published_tutorial, published_at: 4.hours.ago, title: 'ruby development') }
  let!(:js_tutorial)     { create(:tutorial,           published_at: 3.hours.ago, title: 'js with ruby') }
  let!(:groovy_tutorial) { create(:published_tutorial, published_at: 2.hours.ago, title: 'groovy', content_markdown: 'groovy is similar to ruby') }
  let!(:rake_tutorial)   { create(:published_tutorial, published_at: 1.hour.ago,  title: 'ruby-rake') }

  describe 'GET posts' do
    def do_request(params = {})
      get :posts, { q: 'ruby' }.merge(params)
    end

    it 'returns search results' do
      do_request
      expect(response).to have_http_status :ok
      expect(assigns(:posts).map(&:id)).to eq([rake_post, groovy_post, ruby_post, rails_post].map(&:id))
    end

    [nil, 1].each do |page|
      context "when page == #{page}" do
        it 'assigns cover_post and posts' do
          do_request(page: page, per_page: 2)
          expect(response).to have_http_status :ok
          expect(assigns(:posts).map(&:id)).to eq([rake_post, groovy_post].map(&:id))
        end
      end
    end

    context 'when page > 1 is requested' do
      it 'assigns posts, but not cover_post' do
        do_request(page: 2, per_page: 2)
        expect(response).to have_http_status :ok
        expect(assigns(:posts).map(&:id)).to eq([ruby_post, rails_post].map(&:id))
      end
    end
  end

  describe 'GET tutorials' do
    def do_request(params = {})
      get :tutorials, { q: 'ruby' }.merge(params)
    end

    it 'returns search results' do
      do_request
      expect(response).to have_http_status :ok
      expect(assigns(:tutorials).map(&:id)).to eq([rake_tutorial, groovy_tutorial, ruby_tutorial, rails_tutorial].map(&:id))
    end

    [nil, 1].each do |page|
      context "when page == #{page}" do
        it 'assigns cover_tutorial and tutorials' do
          do_request(page: page, per_page: 2)
          expect(response).to have_http_status :ok
          expect(assigns(:tutorials).map(&:id)).to eq([rake_tutorial, groovy_tutorial].map(&:id))
        end
      end
    end

    context 'when page > 1 is requested' do
      it 'assigns tutorials, but not cover_tutorial' do
        do_request(page: 2, per_page: 2)
        expect(response).to have_http_status :ok
        expect(assigns(:tutorials).map(&:id)).to eq([ruby_tutorial, rails_tutorial].map(&:id))
      end
    end
  end
end
