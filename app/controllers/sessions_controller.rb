class SessionsController < ApplicationController

  def new
  end

  def create
    username_or_email = params[:user][:username_or_email]
    password = params[:user][:password]

    login_res = LoginAPIService.new(username_or_email, password).ping
    if login_res.code == 200
      token_res = TokenAPIService.new(login_res["access_token"]).ping

      session[:user_id] = token_res["user"]["id"]
      session[:username] = token_res["user"]["username"]
      session[:admin] = token_res["user"]["admin"]

      redirect_to root_path
    else
      # TODO: Implement in layouts.
      flash[:notice] = login_res["error_description"]
      redirect_to login_path
    end
  end

  def destroy
  end

end
