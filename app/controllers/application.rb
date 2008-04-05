# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthorizationSystem
  include ExceptionNotifiable
  
  # Load ExceptionNotifiable config
  # Consider implications of loading a file every request. 
  # Ideally some better way to handle this with project config
  begin
    mail_yml = YAML.load_file(RAILS_ROOT+'/config/mail.yml')
    mail_env = mail_yml[ENV['RAILS_ENV']]
    ExceptionNotifier.exception_recipients = mail_env[:exception_recipient]
    ExceptionNotifier.sender_address = mail_env[:exception_sender]
  rescue 
  end
  
  # By default all pages are protected
  # Use skip_before_filter on public pages
  before_filter :login_required
    
  # Don't show passwords in the log
  filter_parameter_logging 'password'
  
  # Always localize time when possible
  # By default go with London since it's GMT
  around_filter :set_timezone
  private
  def set_timezone
    logged_in? ? TzTime.zone = current_user.tz : TzTime.zone = TimeZone.new('London')
    # Set the week period for the status bar on in the header
    @week = TimePeriod.week_to_date
    yield
    TzTime.reset!
  end
  
  # Handle the captcha on user login
  def set_captcha
    session[:captcha] = rand(10) + 20
    @captcha = rand(session[:captcha])
  end
  def clear_captcha
    session[:captcha] = nil
  end
  def captcha_passed?
    return false if session[:captcha].nil? or params[:captcha].nil?
    params[:captcha].to_i == session[:captcha]
  end
  
  # Takes in parameters in the form /:year/:month/:day/:period
  # Assigns @period to a range of dates from the implied start to end
  # For example:
  #   /             =>    First of current month, to the end of the month
  #   /2007         =>    January 1, 2007 - December 31, 2007
  #   /2007/1       =>    January 1, 2007 - January 31, 2007
  #   /2007/1/1     =>    January 1, 2007 - Janauary 1, 2007
  #   /2007/1/1/90  =>    January 1, 2007 - April 1, 2007
  def period_assign_whole_month
    params[:period].nil? ? period = 0 : period = params[:period].to_i
    params[:year].nil? ? year = TzTime.now.year : year = params[:year].to_i

    if params[:day].nil?
      day = 1
      if params[:month].nil?
        month = 1
        if params[:year].nil?
          year, month, day = TzTime.now.year, TzTime.now.month, 1
          period += (Date.civil(year, month, -1).day - 1)
        else
          Date.new(year).leap? ? period += 365 : period += 364
        end
      else
        month = params[:month].to_i
        period += (Date.civil(year, month, -1).day - 1)
      end
    else
      month = params[:month].to_i
      day = params[:day].to_i
    end

    @period = Date.new(year, month, day)..(Date.new(year, month, day) + period)
  end
  
  # Takes in parameters in the form /:year/:month/:day/:period
  # Assigns @period to a range of dates from the implied start to end
  # Will only returns a period up to today
  def period_assign_to_today
    year, month, day, period = params[:year], params[:month], params[:day], params[:period]

    if period.nil?
      if day.nil?
        if month.nil?
          if year.nil?
            @period = Date.new(TzTime.now.year, TzTime.now.month, 1)..TzTime.now.to_date
          else
            year = year.to_i
            @period = Date.new(year, 1, 1)..Date.new(year, 12, 31)
          end
        else
          year, month = year.to_i, month.to_i
          @period = Date.new(year, month, 1)..Date.civil(year, month, -1)
        end
      else
        year, month, day = year.to_i, month.to_i, day.to_i
        @period = Date.new(year, month, 1)..Date.new(year, month, day)
      end
    else
      year, month, day, period = year.to_i, month.to_i, day.to_i, period.to_i
      @period = Date.new(year, month, day)..(Date.new(year, month, day) + period)     
    end
  end
end
