require 'rails_helper'

describe TutorialsController do
  describe 'GET #new' do
    render_views

    def do_request
      get :new
    end

    it_behaves_like 'admin new page'
  end

  describe 'POST #create' do
    let(:item) { :tutorial }
    let(:model_class) { Tutorial }
    let(:index_path) { tutorials_path }

    def do_request(params = {})
      post :create, { tutorial: attributes_for(:tutorial) }.merge(params)
    end

    it_behaves_like 'admin create'

    context 'when a user logged in as an admin' do
      before { sign_in_as_admin }

      it 'creates a tutorial' do
        expect {
          do_request(
              tutorial: {
                  title:            'tutorial title',
                  content_markdown: 'content markdown',
                  tag_list:         'ruby'
              }
          )
        }.to change(Tutorial, :count).by(1)

        p = Tutorial.last
        expect(p.slug).to eq('tutorial-title')
        expect(p.title).to eq('tutorial title')
        expect(p.content_markdown).to eq('content markdown')
        expect(p.content_html).to match('<p>content markdown</p>')
        expect(p.tag_list).to eq(['ruby'])
      end
    end
  end

  describe 'GET #index' do
    render_views

    let!(:ruby_tutorial) { create(:tutorial, tag_list: [:ruby]) }
    let!(:go_tutorial) { create(:tutorial, tag_list: [:go]) }

    def do_request(params = {})
      get :index, params
    end

    it 'renders' do
      do_request
      expect(response).to have_http_status(:success)
    end

    it 'assigns tutorials' do
      do_request
      expect(assigns(:tutorials)).to contain_exactly(ruby_tutorial, go_tutorial)
    end

    context 'tag is specified' do
      it 'assigns tutorials that have specified tag' do
        do_request(type: :tutorial, tag: 'ruby')
        expect(assigns(:tutorials)).to contain_exactly(ruby_tutorial)
      end
    end
  end

  describe 'GET #show' do
    render_views

    let!(:p) { create(:tutorial) }
    before { get :show, slug: p.slug }
    it { expect(response).to have_http_status(:success) }
  end
end
