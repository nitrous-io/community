require 'rails_helper'

describe TutorialsController do
  render_views

  describe 'GET new' do
    def do_request
      get :new
    end

    it_behaves_like 'an admin only action'

    context 'when logged in as admin' do
      before { sign_in_as_admin }

      it 'responds with new page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST create' do
    let(:item) { :tutorial }

    def do_request(params = {})
      post :create, { tutorial: attributes_for(:tutorial) }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when logged in as admin' do
      before { sign_in_as_admin }

      it 'creates a tutorial' do
        expect {
          do_request(tutorial: {
            title:            'tutorial title',
            content_markdown: '# content markdown',
            tag_list:         'ruby'
          })
        }.to change(Tutorial, :count).by(1)

        expect(response).to redirect_to(drafts_path)

        o = Tutorial.last
        expect(o.slug).to eq('tutorial-title')
        expect(o.title).to eq('tutorial title')
        expect(o.content_markdown).to eq('# content markdown')
        expect(o.content_html).to match('<h1>content markdown</h1>')
        expect(o.content_text).to match('content markdown')
        expect(o.tag_list).to eq(['ruby'])
      end
    end
  end

  describe 'GET edit' do
    render_views

    subject { create :tutorial }

    def do_request
      get :edit, id: subject.id
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'responds with edit page' do
        do_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH update' do
    subject { create :tutorial }

    def do_request(params = {})
      patch :update, { id: subject.id, tutorial: attributes_for(:tutorial) }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'updates the tutorial' do
        do_request(id: subject.id, tutorial: {
          title: 'updated tutorial title',
          content_markdown: '# updated content markdown',
          tag_list: 'rails',
          cover_image_url: 'http://example.com/a.jpg'
        })

        subject.reload

        expect(response).to redirect_to(tutorial_path(subject))
        expect(subject.title).to eq('updated tutorial title')
        expect(subject.slug).to eq('updated-tutorial-title')
        expect(subject.cover_image_url).to eq('http://example.com/a.jpg')
        expect(subject.content_markdown).to eq('# updated content markdown')
        expect(subject.content_html).to match('<h1>updated content markdown</h1>')
        expect(subject.content_text).to match('updated content markdown')
        expect(subject.tag_list).to eq(['rails'])
      end
    end
  end

  describe 'DELETE destroy' do
    subject { create :tutorial }

    def do_request(params = {})
      delete :destroy, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'deletes the tutorial' do
        expect {
          do_request
        }.to change{ subject.reload.deleted? }.from(false).to(true)

        expect(response).to redirect_to(tutorials_path)
      end
    end
  end

  describe 'POST publish' do
    subject { create :tutorial }

    def do_request(params = {})
      post :publish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'publishes the tutorial' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(false).to(true)

          expect(subject.published_at.to_i).to eq(Time.now.to_i)
        end

        expect(response).to redirect_to(tutorial_path(subject))
      end
    end
  end

  describe 'POST unpublish' do
    subject { create :tutorial }
    before { subject.published! }

    def do_request(params = {})
      post :unpublish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'unpublishes the tutorial' do
        Timecop.freeze do
          expect {
            do_request
          }.to change { subject.reload.published? }.from(true).to(false)

          expect(subject.published_at).to be_nil
        end

        expect(response).to redirect_to(tutorial_path(subject))
      end
    end
  end

  describe 'GET index' do
    let!(:rust_tutorial)  { create(:tutorial, title: 'rust', tag_list: %w(rust go)) }
    let!(:rails_tutorial) { create(:published_tutorial, published_at: 1.hour.ago,  title: 'rails-tutorial', tag_list: %w(rails ruby)) }
    let!(:go_tutorial)    { create(:published_tutorial, published_at: 2.hours.ago, title: 'go-tutorial',    tag_list: %w(go martini)) }
    let!(:java_tutorial)  { create(:published_tutorial, published_at: 3.hours.ago, title: 'java-tutorial',  tag_list: %w(java      )) }
    let!(:js_tutorial)    { create(:published_tutorial, published_at: 4.hours.ago, title: 'js-tutorial',    tag_list: %w(javascript)) }
    let!(:cgo_tutorial)   { create(:published_tutorial, published_at: 5.hours.ago, title: 'cgo-tutorial',   tag_list: %w(go c      )) }

    def do_request(params = {})
      get :index, params
    end

    it 'responds with index page' do
      do_request
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    [nil, 1].each do |page|
      context "when page == #{page}" do
        it 'assigns content' do
          do_request(page: page, per_page: 2)
          expect(assigns(:content).map(&:id)).to eq([rails_tutorial, go_tutorial].map(&:id))
        end
      end
    end

    context 'when page > 1 is requested' do
      it 'assigns content' do
        do_request(page: 2, per_page: 2)
        expect(assigns(:content).map(&:id)).to eq([java_tutorial, js_tutorial].map(&:id))
      end
    end

    context 'tag is specified' do
      it 'assigns content that have specified tag' do
        do_request(tag: 'go')
        expect(assigns(:content).map(&:id)).to eq([go_tutorial, cgo_tutorial].map(&:id))
      end
    end
  end

  describe 'GET show' do
    subject { create :published_tutorial }

    def do_request
      get :show, slug: subject.slug
    end

    it 'responds with show page' do
      do_request
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end
  end
end
