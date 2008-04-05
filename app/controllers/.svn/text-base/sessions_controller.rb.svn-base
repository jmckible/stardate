class SessionsController < ApplicationController
  skip_before_filter :login_required
  layout 'public'

  # GET /login
  def login
  end

  # GET /logout
  def logout
    clear_session
    redirect_to welcome_path
  end

  # POST /authenticate
  def authenticate
    user = User.authenticate(params[:email], params[:password])
    if user.nil?
      flash[:notice] = 'Invalid username/password'
      render :action=>'login'
    else
      session[:user_id] = user.id
      cookies[:user_id] = {:value=>user.id.to_s, :expires=>2.years.from_now}
      cookies[:password_hash] = {:value=>user.password_hash, :expires=>2.years.from_now}
      redirect_to home_path
    end
  end
end
