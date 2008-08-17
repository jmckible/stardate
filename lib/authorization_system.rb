module AuthorizationSystem
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end
  
  protected
  def logged_in?
    !@current_user.nil?
  end

  # Returns the currently logged in user
  def current_user
    @current_user ||= User.find(session[:user_id])
  end
  
  # Assigns the current user
  def current_user=(user)
    return if user.nil?
    session[:user_id] = user.id
    cookies[:user_id] = user.id.to_s
    cookies[:password_hash] = user.password_hash
    @current_user = user
  end

  # To protect a controller, use this method as a filter
  # before_filter :login_required
  def login_required
    access_denied unless session_login || cookie_login
  end

  # If the user can't be logged in with supplied credentials
  # redirect to login page, or send 401 depending on request format
  def access_denied
    clear_session
    redirect_to login_path and return false
  end

  # Log in using the session
  # Session is assumed to be secure
  def session_login
    @current_user = User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    return false
  end

  # Log in with cookie
  def cookie_login
    @current_user = User.find(cookies[:user_id])
    return @current_user.password_hash == cookies[:password_hash] 
  rescue 
    return false
  end
  
  # Clean out the session and cookie 
  def clear_session
    session[:user_id] = nil
    cookies[:user_id] = nil
    cookies[:password_hash] = nil
  end
end