class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :header

  private 

  def header
   @current_user = session[:username]
   @admin = session[:admin]
  end

  def authenticate_user
    if session[:user_id]
      redirect_to root_path
      return true
    else 
      return false
    end
  end

end
