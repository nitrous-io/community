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

  describe 'GET #edit' do
    subject { create(:tutorial) }
    render_views

    def do_request
      get :edit, id: subject.id
    end

    it_behaves_like 'admin edit page'
  end

  describe 'PUT #update' do
    let(:item) { :tutorial }
    let(:index_path) { tutorials_path }

    subject { create(:tutorial) }

    def do_request(params = {})
      put :update, { id: subject.id, tutorial: attributes_for(:tutorial) }.merge(params)
    end

    it_behaves_like 'admin update'

    context 'when a user logged in as an admin' do
      before { sign_in_as_admin }

      it 'updates a tutorial' do
        do_request(id: subject.id,
                   tutorial: {
                       title: 'updated tutorial title',
                       content_markdown: 'updated content markdown',
                       tag_list: 'rails',
                       cover_image_url: 'http://example.com/a.jpg'})
        subject.reload
        expect(subject.title).to eq('updated tutorial title')
        expect(subject.content_markdown).to eq('updated content markdown')
        expect(subject.cover_image_url).to eq('http://example.com/a.jpg')
        expect(subject.slug).to eq('updated-tutorial-title')
        expect(subject.content_html).to match('<p>updated content markdown</p>')
        expect(subject.tag_list).to eq(['rails'])
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:index_path) { tutorials_path }

    subject { create(:tutorial) }

    def do_request(params = {})
      delete :destroy, { id: subject.id }.merge(params)
    end

    it_behaves_like 'admin delete'
  end

  describe 'PUT #publish' do
    let(:index_path) { tutorials_path }
    let(:item_name) { :tutorial }

    subject { create(:tutorial) }

    def do_request(params = {})
      put :publish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'admin publish'
  end

  describe 'PUT #unpublish' do
    let(:index_path) { tutorials_path }

    subject { create(:tutorial) }

    def do_request(params = {})
      put :unpublish, { id: subject.id }.merge(params)
    end

    it_behaves_like 'admin unpublish'
  end

  describe 'GET #index' do
    render_views

    let!(:ruby_tutorial) { create(:published_tutorial, tag_list: [:ruby]) }
    let!(:go_tutorial) { create(:published_tutorial, tag_list: [:go]) }

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


    it_behaves_like 'admin index' do
      let(:collection) { [ruby_tutorial, go_tutorial]}
      let(:collection_name) { :tutorials }
    end

    context 'with pagination' do
      before do
        Timecop.freeze(2.days.ago) { ruby_tutorial.update_attribute(:title, 'new post title') }
      end

      specify do
        do_request(per_page: 1, page: 1)
        expect(assigns(:tutorials)).to contain_exactly(go_tutorial)
      end

      context 'not first page' do
        specify do
          do_request(per_page: 1, page: 2)
          expect(response).to render_template('tutorials/_list')
          doc = Nokogiri::HTML(response.body)
          expect(doc.css("a[href=\"#{tutorials_slugged_path(ruby_tutorial.slug)}\"]")).not_to be_empty
        end
      end
    end
  end

  describe 'GET #show' do
    render_views

    let!(:tutorial) { create(:published_tutorial) }

    def do_request
      get :show, slug: tutorial.slug
    end

    it 'renders' do
      do_request
      expect(response).to have_http_status(:success)
    end

    it 'shows upvote button' do
      do_request
      doc = Nokogiri::HTML(response.body)
      selector = "form[action='#{tutorial_likes_path(tutorial_id: tutorial.id)}']"
      expect(doc.css(selector)).not_to be_empty
    end

    context 'a user has upvoted the tutorial' do
      let(:user) { create(:user) }

      before do
        create(:like, parent: tutorial, user: user)
        sign_in(user)
      end

      it 'shows downvote button' do
        do_request
        doc = Nokogiri::HTML(response.body)
        selector = "form[action='#{tutorial_likes_path(tutorial_id: tutorial.id)}'] input[name=_method][value=delete]"
        expect(doc.css(selector)).not_to be_empty
      end
    end

    it_behaves_like('commentable') { let(:parent) { tutorial } }
    it_behaves_like('admin show') { let(:item) { tutorial } }
  end
end
