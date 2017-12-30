module AuthorizationSystem
  def self.included(base)
    base.send :helper_method, :logged_in?
  end

  protected
  def logged_in?
    !@user.nil?
  end

  def attempt_login
    session_login || cookie_login
  end

  def login_required
    access_denied unless attempt_login
  end

  def access_denied
    clear_session_and_cookies
    redirect_to new_session_path and return false
  end

  def session_login
    @user = User.find session[:user_id]
    @household = @user.household
  rescue ActiveRecord::RecordNotFound
    @user = nil
    @household = nil
    return false
  end

  def cookie_login
    @user = User.find cookies[:user_id]
    @household = @user.household
    return @user.password_hash == cookies[:password_hash]
  rescue ActiveRecord::RecordNotFound
    @user = nil
    @household = nil
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
