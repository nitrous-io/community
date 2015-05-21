module SessionHelper
  def sign_in(user = nil)
    session[:user_id] = user.try(:id) || 1
    create(:user, id: session[:user_id]) unless User.find_by_id(session[:user_id])
  end

  def sign_out
    session[:user_id] = nil
  end

  def sign_in_as_admin(user = nil)
    session[:user_id] = user.try(:id) || 1
    user = User.find_by_id(session[:user_id])
    if user
      user.update_attribute(:admin, true) unless user.admin
    else
      create(:user, id: session[:user_id], admin: true)
    end
  end
end