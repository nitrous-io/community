class LoginAPIService
  include HTTParty
  base_uri 'https://pro.n2ostaging.com/api/v0'
  # If successful: Returns HTTP Status OK, and JSON response {access_token:"", token_type":"Bearer"}
  # If unsuccessful: Returns eg. {"error"=>"invalid_grant", "error_description"=>"incorrect username or password"} 
  
  def initialize(username, password)
    @options = { query: {username: username, password: password, grant_type: "password"} }
  end

  def ping
    self.class.post("/oauth/token", @options)
  end

end
