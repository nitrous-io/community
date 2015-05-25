class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    return @current_user if @current_user
    user = session[:user_id] ? User.find_by_id(session[:user_id]) : nil
    return nil if user.nil?
    @current_user = user.outdated? ? fetch_user(user) : user
  end

  def fetch_user(user, client = nil)
    client ||= Nitrous::OauthClient.new(user.nitrous_oauth_token)
    client.fetch_user
    if client.success?
      user.username            = client.user.username
      user.name                = client.user.name
      user.email               = client.user.email
      user.nitrous_oauth_token = client.token
      user.admin               = client.user.admin
      user.last_fetched_at     = Time.now
      unless user.save
        Rails.logger.warn("Failed to update user(#{user.inspect}) information: #{user.errors.full_messages.join(',')}")
      end
    else
      user.update_attribute(:admin, false)
      Rails.logger.warn("Failed to update user(#{user.inspect}) information: #{client.last_error_description}")
    end
    user
  end

  # FIXME: I will remove it once we have our error page
  def not_found
    render :file => 'public/404.html', status: :not_found, layout: nil
  end


  protected
  def verify_logged_out
    redirect_to root_path if current_user
  end

  def verify_logged_in
    unless current_user
      flash[:error] = "You need to log in"
      redirect_to login_path
    end
  end

  def verify_admin
    redirect_to root_path unless current_user.try(:admin)
  end
end
