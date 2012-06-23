class SessionsController < ApplicationController
  skip_before_filter :login_required

  # GET /sessions/new
  def new
    # Redirect if the user is already logged in
    attempt_login 
    redirect_to root_path if logged_in?
  end
  
  # POST /sessions
  def create
    user = User.authenticate params[:email], params[:password]
    if user.nil?
      flash[:notice] = 'Invalid username/password'
      render action: 'new'
    else
      session_and_cookie_for user
      redirect_to root_path
    end
  end
  
  # DELETE /sessions/:id
  def destroy
    clear_session_and_cookies
    redirect_to new_session_path
  end

end
