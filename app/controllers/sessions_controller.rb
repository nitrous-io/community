class SessionsController < ApplicationController
  before_action :verify_logged_out, only: [:new, :create]

  def new
  end

  def create
    username_or_email = params[:user][:username_or_email]
    password = params[:user][:password]

    client = Nitrous::OauthClient.new
    client.authorize(username_or_email, password)

    if client.success?
      client.fetch_user
      if client.success?
        user = client.user
        session[:user_id] = user.id
        u = User.find_by_id(user.id)
        if u
          u.username = user.username
          u.email = user.email
          u.nitrous_oauth_token = client.token
          u.admin = user.admin
        else
          u = User.new(id:              user.id,
                   username:            user.username,
                   email:               user.email,
                   nitrous_oauth_token: client.token,
                   admin:               user.admin)
        end

        flash[:error] = u.errors.full_messages.join(',') unless u.save
      else
        flash[:error] = client.last_error_description
      end

      redirect_to root_path
    else
      flash[:error] = client.last_error_description
      redirect_to login_path
    end
  end

  def destroy
    client = Nitrous::OauthClient.new(current_user.nitrous_oauth_token)
    client.logout
    if client.success?
      reset_session
    else
      Rails.logger.error("Failed to logout user(#{current_user.inspect})", client.last_error_description)
    end
    redirect_to root_path
  end
end
