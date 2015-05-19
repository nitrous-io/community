class UserService
  attr_reader :id, :username, :admin

  def initialize(session)
    @id = session[:user_id]
    @username = session[:username]
    @admin = session[:admin]
  end
end