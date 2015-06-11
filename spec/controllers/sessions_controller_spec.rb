require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET new" do
    render_views

    def do_request
      get :new
    end

    context "when user not logged in" do

      it 'renders new template' do
        do_request
        is_expected.to render_template(:new)
      end

      it 'render successfully' do
        do_request
        expect(response).to have_http_status(:success)
      end
    end

    context "when user logged in" do
      before { sign_in }

      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST create" do
    let(:username) { 'bighero' }
    let(:password) { 'baymaxxy' }
    let(:token) { 'T0K3N' }
    let(:oauth_url) { sprintf('%s/oauth/token?grant_type=password&password=%s&username=%s', ENV['NITROUS_URL'], password, username) }
    let(:user_url) { sprintf('%s/user', ENV['NITROUS_URL']) }
    let(:user_info) { { 'id' => 67, 'name' => '', 'username' => 'bighero', 'email' => 'nitrousbighero@gmail.com', 'admin' => false } }

    def do_request(params = {})
      post :create, { user: { username_or_email: username, password: password } }.merge(params)
    end

    context "with success" do
      let(:login_response_body) { JSON.dump({ 'access_token' => token, 'token_type' => 'Bearer' }) }
      let(:token_response_body) { JSON.dump({ 'user' => user_info }) }

      before do
        stub_request(:post, oauth_url).
            to_return(status: 200, headers: { 'content-type' => ['application/json; charset=utf-8'] }, body: login_response_body)
        stub_request(:get, user_url).
            with(headers: { 'Authorization' => 'Bearer %s' % token }).
            to_return(status: 200, headers: { 'content-type' => ['application/json; charset=utf-8'] }, body: token_response_body)
      end

      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to(root_path)
      end

      it 'sets session' do
        do_request
        expect(session[:user_id]).to eq(67)
      end

      it 'creates a user' do
        Timecop.freeze do
          expect { do_request }.to change(User, :count).by(1)
          u = User.last
          expect(u.id).to eq(user_info['id'])
          expect(u.name).to eq(user_info['name'])
          expect(u.username).to eq(user_info['username'])
          expect(u.email).to eq(user_info['email'])
          expect(u.admin).to eq(user_info['admin'])
          expect(u.email_md5).to eq(Digest::MD5.hexdigest(user_info['email']))
          expect(u.last_fetched_at.to_i).to eq(Time.now.to_i)
        end
      end

      context 'the user exists' do
        let!(:user) { create(:user, id: 67) }

        before { user.update_attribute(:last_fetched_at, 2.days.ago) }

        it 'updates the user' do
          Timecop.freeze do
            expect { do_request }.not_to change(User, :count)
            u = User.find_by_id(67)
            expect(u.id).to eq(user_info['id'])
            expect(u.name).to eq(user_info['name'])
            expect(u.username).to eq(user_info['username'])
            expect(u.email).to eq(user_info['email'])
            expect(u.admin).to eq(user_info['admin'])
            expect(u.email_md5).to eq(Digest::MD5.hexdigest(user_info['email']))
            expect(u.last_fetched_at.to_i).to eq(Time.now.to_i)
          end
        end
      end

      context 'return_to is specified' do
        it 'redirects to the page' do
          do_request(return_to: 'http://example.com/return')
          expect(response).to redirect_to('http://example.com/return')
        end
      end
    end

    context "with failure" do
      let(:login_response_body) { JSON.dump({ 'error' => 'invalid_grant', 'error_description' => 'incorrect username or password' }) }

      before do
        stub_request(:post, sprintf('%s/oauth/token?grant_type=password&password=%s&username=%s', ENV['NITROUS_URL'], password, username)).
            to_return(status: 400, headers: { 'content-type' => ['application/json; charset=utf-8'] }, body: login_response_body)
      end

      it 'redirects to login page' do
        do_request
        expect(response).to redirect_to(login_path)
      end

      it 'does not set session' do
        do_request
        expect(session[:user_id]).to eq(nil)
      end
    end
  end

  describe "DELETE destroy" do
    def do_request
      delete :destroy
    end

    let(:token) { 'token' }

    before do
      stub_request(:delete, sprintf('%s/logout', ENV['NITROUS_URL'])).
          with(headers: { 'Authorization' => 'Bearer %s' % token }).
          to_return(status: 200, headers: {}, body: '')
      u                 = create(:user, nitrous_oauth_token: token)
      session[:user_id] = u.id
    end

    it 'redirects to home page' do
      do_request
      expect(response).to redirect_to(root_path)
    end

    it 'resets session' do
      do_request
      expect(session).to be_blank
    end
  end
end
