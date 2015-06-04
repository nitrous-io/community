require 'rails_helper'

describe SearchController do

  describe "GET #search" do
    def do_request(params = {})
      get :search, { q: 'rails' }.merge(params)
    end

    let!(:rails_post) { create(:published_post, title: 'rails') }
    let!(:rails_tutorial) { create(:published_tutorial, title: 'rails') }
    let!(:go_post) { create(:published_post, title: 'go') }
    let!(:go_tutorial) { create(:published_tutorial, title: 'go') }

    it 'renders search results' do
      do_request
      expect(response).to be_success
      expect(assigns(:posts)).to contain_exactly(rails_post)
      expect(assigns(:tutorials)).to contain_exactly(rails_tutorial)
    end
  end
end
