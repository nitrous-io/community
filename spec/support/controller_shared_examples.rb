require 'rails_helper'

shared_examples 'an admin only action' do
  context 'when not logged in' do
    it 'returns 403 forbidden' do
      do_request
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as regular user' do
    before { sign_in }

    it 'returns 403 forbidden' do
      do_request
      expect(response).to have_http_status(:forbidden)
    end
  end
end
