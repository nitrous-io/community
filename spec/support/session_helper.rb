module SessionHelper
  def sign_in(opt = {})
    session[:user_id] = opt.fetch(:user_id, 1)
    create(:user, id: session[:user_id]) unless User.find_by_id(session[:user_id])
  end

  def sign_out
    session[:user_id] = nil
  end

  def sign_in_as_admin(opt = {})
    session[:user_id] = opt.fetch(:user_id, 1)
    user = User.find_by_id(session[:user_id])
    if user
      if user.admin
        user.update_attribute(:admin, true)
      end
    else
      create(:user, id: session[:user_id], admin: true)
    end
  end
end