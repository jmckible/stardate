class ApplicationController < ActionController::Base
  include AuthorizationSystem
  
  # By default all pages are protected
  # Use skip_before_filter on public pages
  before_filter :login_required
    
  # Don't show passwords in the log
  filter_parameter_logging 'password'
  
  before_filter :set_time_zone
  
  protected
  def set_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end

end
