class SessionsController < ApplicationController

  def new
  end

  def create
    username_or_email = params[:user][:username_or_email]
    password = params[:user][:password]

    login_res = LoginAPIService.new(username_or_email, password).ping
    if login_res.code == 200

      access_token = login_res["access_token"]
      token_res = TokenAPIService.new(access_token).ping

      session[:user_id] = token_res["user"]["id"]
      session[:username] = token_res["user"]["username"]
      session[:admin] = token_res["user"]["admin"]
      session[:token] = access_token 

      redirect_to root_path
    else
      # TODO: Implement in layouts.
      flash[:notice] = login_res["error_description"]
      redirect_to login_path
    end
  end

  def destroy
    logout_res = LogoutAPIService.new(session[:token]).ping
    if logout_res.code == 200
      reset_session
    else
      puts logout_res
    end
    redirect_to root_path
  end

end
