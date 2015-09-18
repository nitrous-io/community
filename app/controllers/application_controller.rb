class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def current_user
    return @current_user if @current_user
    user = session[:user_id] ? User.find_by_id(session[:user_id]) : nil
    return nil if user.nil?
    @current_user = user.outdated? ? fetch_user(user) : user
  end

  def current_user_id
    session[:user_id]
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

  protected
  def verify_logged_out
    return unless current_user
    perform_redirect
  end

  def verify_logged_in
    return if current_user
    if request.xhr?
      render json: { 'error': 'You need to be logged in' }, status: :forbidden
    else
      flash[:error] = "You need to be logged in"
      redirect_to login_path
    end
  end

  def verify_admin
    return if current_user.try(:admin)
    render plain: 'Forbidden', status: :forbidden
  end

  def record_not_found
    render file: 'public/404.html', status: :not_found, layout: nil
  end

  def perform_redirect
    if (uri = params[:redirect_to]).present?
      begin
        u = URI.parse(uri)
      rescue
      else
        redirect_to u.relative? ? uri : root_path
        return
      end
    end
    redirect_to root_path
  end
end
