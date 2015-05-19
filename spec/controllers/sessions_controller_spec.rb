require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET new" do
    def do_request
      get :new
    end

    context "when user not logged in" do
      render_views

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
      before { session[:user_id] = '1' }

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
    let(:user_info) { {'id'=>67, 'username'=>'bighero', 'email'=>'nitrousbighero@gmail.com', 'admin'=>false} }

    def do_request(params =  {username_or_email: username, password: password})
      post :create, user: params
    end

    context "with success" do
      let(:login_response_body) { JSON.dump({'access_token' => token, 'token_type' => 'Bearer'}) }
      let(:token_response_body) { JSON.dump({'user'=>user_info}) }

      before do
        stub_request(:post, oauth_url).
            to_return(status: 200, headers: {'content-type'=>['application/json; charset=utf-8']}, body: login_response_body)
        stub_request(:get, user_url).
            with(headers: { 'Authorization' => 'Bearer %s' % token }).
            to_return(status: 200, headers: {'content-type'=>['application/json; charset=utf-8']}, body: token_response_body)
      end

      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to(root_path)
      end

      it 'sets session' do
        do_request
        expect(session[:username]).to eq(username)
        expect(session[:user_id]).to eq(67)
        expect(session[:admin]).to eq(false)
        expect(session[:token]).to eq('T0K3N')
      end
    end

    context "with failure" do
      let(:login_response_body) { JSON.dump({'error' => 'invalid_grant', 'error_description' => 'incorrect username or password'}) }

      before do
        stub_request(:post, sprintf('%s/oauth/token?grant_type=password&password=%s&username=%s', ENV['NITROUS_URL'], password, username)).
            to_return(status: 400, headers: {'content-type'=>['application/json; charset=utf-8']}, body: login_response_body)
      end

      it 'redirects to login page' do
        do_request
        expect(response).to redirect_to(login_path)
      end

      it 'does not set session' do
        do_request
        expect(session[:username]).to eq(nil)
        expect(session[:user_id]).to eq(nil)
        expect(session[:admin]).to eq(nil)
        expect(session[:token]).to eq(nil)
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
      session[:token] = token
    end

    it 'redirects to home page' do
      do_request
      expect(response).to redirect_to(root_path)
    end

    it 'resets session' do
      do_request
      expect(session).to be_blank
    end

    context 'with failture' do
      before do
        stub_request(:delete, sprintf('%s/logout', ENV['NITROUS_URL'])).
            with(headers: { 'Authorization' => 'Bearer %s' % token }).
            to_return(status: 400, headers: {}, body: '')
      end

      it 'resets session' do
        do_request
        expect(session).to_not be_blank
      end
    end
  end
end
