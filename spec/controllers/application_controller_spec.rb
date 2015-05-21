require 'rails_helper'

describe ApplicationController do
  controller do
    def index
    end
  end

  describe 'current_user' do
    let!(:user) { create(:user) }

    before { session[:user_id] = user.id }

    it 'fetch user based on session user_id' do

      expect(controller.current_user).to eq(user)
    end

    context 'user information is outdated' do
      let(:user_url) { sprintf('%s/user', ENV['NITROUS_URL']) }
      let(:token) { 'T0K3N' }
      let(:user_info) { { 'id' => user.id, 'name' => 'got name', 'username' => user.username, 'email' => user.email, 'admin' => true } }
      let(:user_response_body) { JSON.dump({ 'user' => user_info }) }

      before do
        user.update_attributes(last_fetched_at: 2.days.ago, nitrous_oauth_token: token, admin: false)
        stub_request(:get, user_url).
            with(headers: { 'Authorization' => 'Bearer %s' % token }).
            to_return(status: 200, headers: { 'content-type' => ['application/json; charset=utf-8'] }, body: user_response_body)
      end

      it 're-fetches from nitrous' do
        Timecop.freeze do
          user = controller.current_user
          expect(user.last_fetched_at.to_i).to eq(Time.now.to_i)
          expect(user.admin).to eq(true)
          expect(user.name).to eq('got name')
        end
      end
    end
  end
end
