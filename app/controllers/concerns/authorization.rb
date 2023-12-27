module Authorization
  extend ActiveSupport::Concern

  included do
    helper_method :logged_in?
  end

  protected

  def access_denied
    reset_session
    redirect_to new_session_path
  end

  def login_as(user)
    session[:user_id] = user.id
    session_login
  end

  def logged_in?
    Current.user.present?
  end

  def login_required
    access_denied unless session_login
  end

  def session_login
    Current.user = User.find session[:user_id]
  rescue ActiveRecord::RecordNotFound
    return false
  end

end
