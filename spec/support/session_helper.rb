module SessionHelper
  def sign_in(opt = {})
    session[:user_id] = opt.fetch(:user_id, 1)
    session[:username] = opt.fetch(:username, 'username')
  end

  def sign_out
    session[:user_id] = nil
    session[:username] = nil
    session[:admin] = nil
  end

  def sign_in_as_admin(opt = {})
    session[:user_id] = opt.fetch(:user_id, 1)
    session[:username] = opt.fetch(:username, 'username')
    session[:admin] = true
  end
end