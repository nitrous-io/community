class LogoutAPIService
  include HTTParty
  base_uri 'https://pro.n2ostaging.com/api/v0'
  # If successful: Returns HTTP Status OK
  # If unsuccessful: Returns eg. {"error":"invalid_request","error_description":"auth token is required"}
  def initialize(token)
    @options = { headers: { "Authorization" => "Bearer "+token} }
  end
  
  def ping
    self.class.delete("/logout", @options)
  end

end
