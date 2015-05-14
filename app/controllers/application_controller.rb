class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # TODO: Refresh this from API every x seconds denoted by a session[:refreshed_data]
  before_action :header

  private

  def header
    @current_user = session[:username]
    @admin = session[:admin]
  end

  def current_username
    session[:username]
  end

  def verify_logged_out
    if session[:user_id]
      redirect_to root_path
    end
  end

  def verify_logged_in
    if session[:user_id].nil?
      flash[:error] = "You need to log in"
      redirect_to login_path
    end
  end

  def verify_admin
    if session[:admin] != true
      redirect_to root_path
    end
  end
end
