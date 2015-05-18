require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET new" do
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
      before { session[:user_id] = '1' }

      it 'redirects to home page' do
        do_request
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST create" do
    def do_request(params)
      post :create, user: params
    end

    context "with success" do
      let(:query_string) { 'grant_type=password&password=baymaxxy&username=bighero' }
      let(:login_response_body) { JSON.dump('access_token' => 'T0K3N', 'token_type' => 'Bearer') }
      let(:token_response_body) { JSON.dump({'user'=>{'id'=>67, 'username'=>'bighero', 'email'=>'nitrousbighero@gmail.com', 'admin'=>false}}) }

      before do
        stub_request(:post, sprintf('%s/oauth/token?%s', ENV['NITROUS_URL'], query_string)).
            to_return(status: 200, headers: {}, body: login_response_body)
        stub_request(:get, sprintf('%s/user', ENV['NITROUS_URL'])).
            to_return(status: 200, headers: {}, body: token_response_body)
      end


      it 'redirects to home page' do
        do_request({username_or_email: "bighero", password: "baymaxxy"})
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      let(:query_string) { 'grant_type=password&password=fakepw&username=fakehero' }
      let(:login_response_body) { JSON.dump('error' => 'invalid_grant', 'error_description' => 'incorrect username or password') }

      before do
        stub_request(:post, sprintf('%s/oauth/token?%s', ENV['NITROUS_URL'], query_string)).
            to_return(status: 400, headers: {}, body: login_response_body)
      end

      it 'redirects to login page' do
        do_request({username_or_email: "fakehero", password: "fakepw"})
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE destroy" do
    def do_request
      delete :destroy
    end

    let(:token) { 'faketoken' }
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
  end
end
