require 'rails_helper'

shared_examples 'admin new page' do
  it 'redirects to home page' do
    do_request
    expect(response).to redirect_to(root_path)
  end

  context 'when logged in' do
    before { sign_in }

    it 'redirects to home page' do
      do_request
      expect(response).to redirect_to(root_path)
    end

    context 'when a user is admin' do
      before { sign_in_as_admin }

      it 'renders new template' do
        do_request
        expect(response).to render_template(:new)
      end

      it 'renders successfully' do
        do_request
        expect(response).to have_http_status(:success)
      end
    end
  end
end

shared_examples 'admin edit page' do
  it 'redirects to home page' do
    do_request
    expect(response).to redirect_to(root_path)
  end

  context 'when logged in' do
    before { sign_in }

    it 'redirects to home page' do
      do_request
      expect(response).to redirect_to(root_path)
    end

    context 'when a user is admin' do
      before { sign_in_as_admin }

      it 'renders new template' do
        do_request
        expect(response).to render_template(:edit)
      end

      it 'renders successfully' do
        do_request
        expect(response).to have_http_status(:success)
      end
    end
  end
end

shared_examples 'admin create' do
  it 'redirects to home page' do
    do_request
    expect(response).to redirect_to(root_path)
  end

  context 'when logged in' do
    before { sign_in }

    it 'redirects to home page' do
      do_request
      expect(response).to redirect_to(root_path)
    end

    context 'when a user is admin' do
      before { sign_in_as_admin }

      context 'with valid parameters' do
        it 'creates a post' do
          expect { do_request }.to change(model_class, :count).by(1)
        end

        it 'redirects to post index page' do
          do_request
          expect(response).to redirect_to(index_path)
        end
      end

      context 'with invalid params' do
        it 'renders new template' do
          expect { do_request(item => attributes_for(item, :invalid)) }.not_to change(model_class, :count)
          expect(response).to render_template(:new)
        end
      end
    end
  end
end