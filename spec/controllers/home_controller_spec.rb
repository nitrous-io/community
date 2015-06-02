require 'rails_helper'

describe HomeController do
  describe 'GET #index' do
    render_views

    let!(:p) { create(:published_post) }
    let!(:tutorial) { create(:published_tutorial) }

    def do_request
      get :index
    end

    it 'renders published posts and tutorials' do
      do_request
      expect(response).to be_success
      expect(assigns(:posts)).to contain_exactly(p)
      expect(assigns(:tutorials)).to contain_exactly(tutorial)
    end
  end
end
