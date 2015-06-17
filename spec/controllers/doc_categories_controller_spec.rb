require 'rails_helper'

RSpec.describe DocCategoriesController, type: :controller do
  render_views

  describe 'GET index' do
    let!(:using_the_ide)   { create :doc_category, name: 'Using the IDE',   position: 2 }
    let!(:preview)         { create :doc_category, name: 'Preview',         position: 3 }
    let!(:getting_started) { create :doc_category, name: 'Getting Started', position: 1 }
    let!(:nitrous_desktop) { create :doc_category, name: 'Nitrous Desktop', position: 4 }

    def do_request
      get :index
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'returns list of doc categories ordered by position' do
        do_request

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
        expect(assigns(:content).map(&:id)).to eq ([getting_started, using_the_ide, preview, nitrous_desktop].map(&:id))
      end
    end
  end

  describe 'POST create' do
    def do_request(params={})
      post :create, params
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'creates a category' do
        expect {
          do_request(doc_category: { name: 'Getting Started', position: 5 })
        }.to change(DocCategory, :count).by(1)

        expect(response).to redirect_to(doc_categories_path)

        c = DocCategory.last
        expect(c.name).to eq('Getting Started')
        expect(c.position).to eq(5)
      end
    end
  end

  describe 'PUT update' do
    let!(:using_the_ide)   { create :doc_category, name: 'Using the IDE',   position: 2 }
    let!(:preview)         { create :doc_category, name: 'Preview',         position: 3 }
    let!(:getting_started) { create :doc_category, name: 'Getting Started', position: 1 }
    let!(:nitrous_desktop) { create :doc_category, name: 'Nitrous Desktop', position: 4 }

    def do_request(params={})
      put :update, { doc_categories: {} }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'updates the category' do
        do_request(doc_categories: {
          using_the_ide.id.to_s   => { position: '3', name: 'Using the Editor' },
          preview.id.to_s         => { position: '2', name: 'Preestreno' },
          getting_started.id.to_s => { position: '4', name: 'Becoming a Pro' },
          nitrous_desktop.id.to_s => { position: '1', name: 'Nitrous for iPad' }
        })

        expect(response).to redirect_to(doc_categories_path)

        [using_the_ide, preview, getting_started, nitrous_desktop].map(&:reload)
        expect(using_the_ide.position).to eq(3)
        expect(using_the_ide.name).to eq('Using the Editor')
        expect(preview.position).to eq(2)
        expect(preview.name).to eq('Preestreno')
        expect(getting_started.position).to eq(4)
        expect(getting_started.name).to eq('Becoming a Pro')
        expect(nitrous_desktop.position).to eq(1)
        expect(nitrous_desktop.name).to eq('Nitrous for iPad')
      end
    end
  end

  describe 'DELETE destroy' do
    subject! { create :doc_category }

    def do_request(params = {})
      delete :destroy, { id: subject.id }.merge(params)
    end

    it_behaves_like 'an admin only action'

    context 'when user is logged in as an admin' do
      before { sign_in_as_admin }

      it 'deletes the post' do
        expect {
          do_request
        }.to change(DocCategory, :count).by(-1)

        expect(response).to redirect_to(doc_categories_path)
      end
    end
  end
end
