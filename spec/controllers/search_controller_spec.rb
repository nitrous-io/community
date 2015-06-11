require 'rails_helper'

describe SearchController do
  render_views

  let!(:rails_post) { create(:published_post, title: 'rails') }
  let!(:rails_tutorial) { create(:published_tutorial, title: 'rails') }
  let!(:go_post) { create(:published_post, title: 'go') }
  let!(:go_tutorial) { create(:published_tutorial, title: 'go') }

  describe 'GET #search' do
    def do_request(params = {})
      get :search, { q: 'rails' }.merge(params)
    end

    it 'renders search results' do
      do_request
      expect(response).to be_success
      expect(response).to render_template(:search)
      expect(assigns(:posts)).to contain_exactly(rails_post)
      expect(assigns(:tutorials)).to contain_exactly(rails_tutorial)
    end
  end

  describe 'GET #posts' do
    def do_request(params = {})
      get :posts, { q: 'rails', format: :js }.merge(params)
    end

    it 'return post list partial' do
      do_request
      expect(response).to render_template('posts/_list')
      expect(response.body).to match(posts_slugged_path(rails_post.slug))
    end
  end

  describe 'GET #tutorials' do
    def do_request(params = {})
      get :tutorials, { q: 'rails', format: :js }.merge(params)
    end

    it 'return tutorial list partial' do
      do_request
      expect(response).to render_template('tutorials/_list')
      doc = Nokogiri::HTML(response.body)
      expect(response.body).to match(tutorials_slugged_path(rails_tutorial.slug))
    end
  end
end
