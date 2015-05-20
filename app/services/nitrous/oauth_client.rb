module Nitrous
  UserInfo = Struct.new(:id, :name, :username, :email, :admin)

  class OauthClient
    include HTTParty
    base_uri ENV['NITROUS_URL']

    GRANT_TYPE='password'.freeze
    TOKEN_URL ='/oauth/token'.freeze
    LOGOUT_URL='/logout'.freeze
    USER_URL='/user'.freeze

    attr_accessor :token, :last_error, :last_error_description, :user

    def initialize(token = nil)
      @token = token
    end

    def authorize(username, password)
      response = self.class.post(TOKEN_URL, { query: { username: username, password: password, grant_type: GRANT_TYPE } })
      # If successful: Returns HTTP Status OK, and JSON response {access_token:"", token_type":"Bearer"}
      # If unsuccessful: Returns eg. {"error"=>"invalid_grant", "error_description"=>"incorrect username or password"}
      if response.code >= 200 && response.code < 300
        @token = response['access_token']
      else
        @last_error = response['error']
        @last_error_description = response['error_description']
      end
    end

    def fetch_user
      # If successful: Returns HTTP Status OK
      # If successful: Returns HTTP Status OK, and JSON response {"user":{"id": ,"name": ,"username":"","email": ,"admin":bool,(other container details)}}
      response = self.class.get(USER_URL, { headers: headers })
      if response.code >= 200 && response.code < 300
        user = response['user']
        @user = Nitrous::UserInfo.new(user['id'], user['name'], user['username'], user['email'], user['admin'])
      else
        @last_error = response['error']
        @last_error_description = response['error_description']
      end
    end

    def logout
      # If successful: Returns HTTP Status OK
      # If unsuccessful: Returns eg. {"error":"invalid_request","error_description":"auth token is required"}
      response = self.class.delete(LOGOUT_URL, { headers:  headers })
      if response.code < 200 && response.code >= 300
        @last_error = response['error']
        @last_error_description = response['error_description']
      end
    end

    def success?
      @last_error.nil?
    end

    protected
    def headers
      @token.nil? ? {} : { 'Authorization' => 'Bearer ' + @token }
    end
  end
end