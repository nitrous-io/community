class PagesController < ApplicationController
  def home
    @current_user = session[:username]
  end
end
