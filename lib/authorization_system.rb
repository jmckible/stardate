module AuthorizationSystem
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end
  
  protected
  def logged_in?
    !@current_user.nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end
  
  def current_user=(user)
    return if user.nil?
    @current_user = user
    session_and_cookie_for user
  end
  
  def attempt_login
    session_login || cookie_login
  end

  def login_required
    access_denied unless session_login || cookie_login
  end

  def access_denied
    clear_session_and_cookies
    redirect_to new_session_path and return false
  end

  def session_login
    @current_user = User.find session[:user_id]
  rescue ActiveRecord::RecordNotFound
    @current_user = nil
    return false
  end

  def cookie_login
    @current_user = User.find cookies[:user_id]
    return @current_user.password_hash == cookies[:password_hash] 
  rescue
    @current_user = nil
    return false
  end
  
  def session_and_cookie_for(user)
    session[:user_id] = user.id
    cookies[:user_id] = {value: user.id.to_s, expires: 2.years.from_now}
    cookies[:password_hash] = {value: user.password_hash, expires: 2.years.from_now}
  end
  
  def clear_session_and_cookies
    session[:user_id] = nil
    cookies[:user_id] = nil
    cookies[:password_hash] = nil
  end
  
end