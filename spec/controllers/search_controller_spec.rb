require 'rails_helper'

describe SearchController do

  describe 'GET #search' do
    render_views
    def do_request(params = {})
      get :search, { q: 'rails', type: 'all' }.merge(params)
    end

    let!(:rails_post) { create(:published_post, title: 'rails') }
    let!(:rails_tutorial) { create(:published_tutorial, title: 'rails') }
    let!(:go_post) { create(:published_post, title: 'go') }
    let!(:go_tutorial) { create(:published_tutorial, title: 'go') }

    it 'renders search results' do
      do_request
      expect(response).to be_success
      expect(response).to render_template(:search)
      expect(assigns(:posts)).to contain_exactly(rails_post)
      expect(assigns(:tutorials)).to contain_exactly(rails_tutorial)
    end

    context 'type is tutorials' do
      it 'return tutorial list partial' do
        do_request(type: 'tutorials')
        expect(response).to render_template('tutorials/_list')
        doc = Nokogiri::HTML(response.body)
        expect(doc.css("a[href=\"#{tutorials_slugged_path(rails_tutorial.slug)}\"]")).not_to be_empty
      end
    end

    context 'type is posts' do
      it 'return post list partial' do
        do_request(type: 'posts')
        expect(response).to render_template('posts/_list')
        doc = Nokogiri::HTML(response.body)
        expect(doc.css("a[href=\"#{posts_slugged_path(rails_post.slug)}\"]")).not_to be_empty
      end
    end
  end
end
