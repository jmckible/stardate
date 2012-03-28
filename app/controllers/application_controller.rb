class ApplicationController < ActionController::Base
  include AuthorizationSystem
  
  # By default all pages are protected
  # Use skip_before_filter on public pages
  before_filter :login_required
  
  before_filter :set_time_zone
  
  before_filter :set_household
  
  protected
  def set_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end
  
  def set_household
    @household = current_user.household if logged_in?
  end

end
