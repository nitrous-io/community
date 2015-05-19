class LoginAPIService
  include HTTParty
  base_uri ENV["NITROUS_URL"]
  # If successful: Returns HTTP Status OK, and JSON response {access_token:"", token_type":"Bearer"}
  # If unsuccessful: Returns eg. {"error"=>"invalid_grant", "error_description"=>"incorrect username or password"} 
  
  def initialize(username, password)
    @options = { query: {username: username, password: password, grant_type: "password"} }
  end

  def ping
    self.class.post("/oauth/token", @options)
  end

end
