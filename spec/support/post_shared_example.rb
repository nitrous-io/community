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

      it 'renders edit template' do
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

        it 'redirects to post page' do
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

shared_examples 'admin update' do
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
        it 'redirects to index page' do
          do_request
          expect(response).to redirect_to(index_path)
        end
      end

      context 'with invalid params' do
        it 'render edit template' do
          do_request(item => attributes_for(item, :invalid))
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end

shared_examples 'admin delete' do
  it 'redirects to home page' do
    do_request
    expect(response).to redirect_to(root_path)
  end

  context 'when logged in' do
    before { sign_in }

    it 'redirects to home page' do
      expect { do_request }.not_to change { subject.reload.deleted? }
      expect(response).to redirect_to(root_path)
    end

    context 'when a user is admin' do
      before { sign_in_as_admin }

      it 'sets as deleted' do
        expect { do_request }.to change { subject.reload.deleted? }.from(false).to(true)
      end

      it 'redirects to index page' do
        do_request
        expect(response).to redirect_to(index_path)
      end
    end
  end
end

shared_examples 'admin publish' do
  it 'redirects to home page' do
    do_request
    expect(response).to redirect_to(root_path)
  end

  before { subject.draft! }

  context 'when logged in' do
    before { sign_in }

    it 'redirects to home page' do
      expect { do_request }.not_to change { subject.reload.published? }
      expect(response).to redirect_to(root_path)
    end

    context 'when a user is admin' do
      before { sign_in_as_admin }

      it 'sets as published' do
        expect { do_request }.to change { subject.reload.published? }.from(false).to(true)
      end

      it 'sets published_at' do
        Timecop.freeze do
          do_request
          expect(subject.reload.published_at.to_i).to eq(Time.now.to_i)
        end
      end

      it 'redirects to index page' do
        do_request
        expect(response).to redirect_to(index_path)
      end

      context 'publish_at is specified' do
        it 'updates published_at to specified time' do
          Timecop.freeze do
            do_request(item_name => { published_at: 2.days.from_now })
            expect(subject.reload.published_at.to_i).to eq(2.days.from_now.to_i)
          end
        end
      end
    end
  end
end

shared_examples 'admin unpublish' do
  it 'redirects to home page' do
    do_request
    expect(response).to redirect_to(root_path)
  end

  before { subject.published! }

  context 'when logged in' do
    before { sign_in }

    it 'redirects to home page' do
      expect { do_request }.not_to change { subject.reload.published? }
      expect(response).to redirect_to(root_path)
    end

    context 'when a user is admin' do
      before { sign_in_as_admin }

      it 'sets as unpublished' do
        expect { do_request }.to change { subject.reload.published? }.from(true).to(false)
      end

      it 'resets published_at' do
        expect(subject.reload.published_at).to be_nil
      end

      it 'redirects to index page' do
        do_request
        expect(response).to redirect_to(index_path)
      end
    end
  end
end

shared_examples 'admin index' do
  context 'there are deleted item' do
    before { collection[0].deleted! }

    it 'does not assign deleted item' do
      do_request
      expect(assigns(collection_name)).to contain_exactly(*collection[1..-1])
    end
  end

  context 'some tutorials are unpublished' do
    before { collection[0].draft! }

    it 'does not assign deleted item' do
      do_request
      expect(assigns(collection_name)).to contain_exactly(*collection[1..-1])
    end
  end

  context 'a user is admin' do
    before { sign_in_as_admin }

    context 'some tutorials are deleted' do
      before { collection[0].deleted! }

      it 'assigns all' do
        do_request
        expect(assigns(collection_name)).to contain_exactly(*collection)
      end
    end

    context 'some tutorials are unpublished' do
      before { collection[0].draft! }

      it 'assigns all' do
        do_request
        expect(assigns(collection_name)).to contain_exactly(*collection)
      end
    end
  end
end

shared_examples 'admin show' do
  context 'the item is deleted' do
    before { item.deleted! }
    it 'returns 404' do
      do_request
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'tutorial is unpublished' do
    before { item.draft! }

    it 'does not assign deleted post' do
      do_request
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'a user is admin' do
    before { sign_in_as_admin }

    context 'the item is deleted' do
      before { item.deleted! }
      it 'returns 404' do
        do_request
        expect(response).to have_http_status(:success)
      end
    end

    context 'tutorial is unpublished' do
      before { item.draft! }

      it 'does not assign deleted post' do
        do_request
        expect(response).to have_http_status(:success)
      end
    end
  end
end