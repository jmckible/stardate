class SessionsController < ApplicationController
  skip_before_action :login_required
  skip_before_action :verify_authenticity_token

  def new
    session_login
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by email: params[:email]
    if user&.authenticate params[:password]
      login_as user
      redirect_to root_path
    else
      redirect_to new_session_path, notice: 'Invalid username/password'
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end

end
