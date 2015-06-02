require 'rails_helper'

describe DraftsController do
  describe 'GET #index' do
    let!(:draft_post) { create(:post) }
    let!(:published_post) { create(:published_post) }
    let!(:draft_tutorial) { create(:tutorial) }
    let!(:published_tutorial) { create(:published_tutorial) }

    def do_request
      get :index
    end

    it 'renders drafts' do
      do_request
      expect(response).to be_success
      expect(assigns(:posts)).to contain_exactly(draft_post)
      expect(assigns(:tutorials)).to contain_exactly(draft_tutorial)
    end
  end

end
