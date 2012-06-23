class ApplicationController < ActionController::Base
  include AuthorizationSystem
  
  # By default all pages are protected
  # Use skip_before_filter on public pages
  before_filter :login_required
  
  before_filter :set_time_zone
    
  protected
  def set_time_zone
    Time.zone = @user.time_zone if logged_in?
  end
  
  def redirect_back_or(url)
    redirect_to request.env['HTTP_REFERER'] || url
  end

end
