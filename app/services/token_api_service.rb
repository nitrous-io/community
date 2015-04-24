class TokenAPIService
  include HTTParty
  base_uri 'https://pro.n2ostaging.com/api/v0'
  # If successful: Returns HTTP Status OK, and JSON response {"user":{"id": ,"name": ,"username":"","email": ,"admin":bool,(other container details)}}
  # If unsuccessful: Returns eg. {"error"=>"invalid_token", "error_description"=>"auth token is invalid"}
  
  def initialize(token)
    # Only the rocket symbol works here.
    @options = { headers: { "Authorization" => "Bearer "+token} }
  end

  def ping
    self.class.get("/user", @options)
  end
end
