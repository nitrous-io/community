require 'rails_helper'

describe 'Session management' do
  let(:username) { 'bighero'}
  let(:password) { 'password'}
  let(:token) { 'token' }

  let(:oauth_url) { sprintf('%s/oauth/token?grant_type=password&password=%s&username=%s', ENV['NITROUS_URL'], password, username) }
  let(:user_url) { sprintf('%s/user', ENV['NITROUS_URL']) }
  let(:user_info) { {'id'=>67, 'username'=>'bighero', 'email'=>'nitrousbighero@gmail.com', 'community_admin'=>false} }

  let(:login_response_body) { JSON.dump({'access_token' => token, 'token_type' => 'Bearer'}) }
  let(:token_response_body) { JSON.dump({'user'=>user_info}) }

  it 'keeps user_id in session table' do
    stub_request(:post, oauth_url).
        to_return(status: 200, headers: {'content-type'=>['application/json; charset=utf-8']}, body: login_response_body)
    stub_request(:get, user_url).
        with(headers: { 'Authorization' => 'Bearer %s' % token }).
        to_return(status: 200, headers: {'content-type'=>['application/json; charset=utf-8']}, body: token_response_body)

    post '/sessions', user: { username_or_email: username, password: password }

    session = Session.last
    expect(session).not_to be_nil
    expect(session.user_id).to eq(user_info['id'])
  end
end
