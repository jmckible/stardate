class ApplicationController < ActionController::Base
  include Authorization, Turbo::Redirection

  # By default all pages are protected
  # Use skip_before_filter on public pages
  before_action :login_required

  before_action :set_time_zone

  protected
  def redirect_back_or(url)
    redirect_to request.env['HTTP_REFERER'] || url
  end

  def set_period
    begin
      @start = Date.new params[:start][:year].to_i, params[:start][:month].to_i, params[:start][:day].to_i
    rescue ArgumentError, NoMethodError
      @start = Time.zone.now.to_date - 365
    end
    begin
      @finish = Date.new params[:finish][:year].to_i, params[:finish][:month].to_i, params[:finish][:day].to_i
    rescue ArgumentError, NoMethodError
      @finish = Time.zone.now.to_date
    end
    @start  = @user.created_at.to_date if @start < @user.created_at.to_date
    @period = @start..@finish
  end

  def set_time_zone
    Time.zone = @user.time_zone if logged_in?
  end

end
