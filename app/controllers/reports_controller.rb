class ReportsController < ApplicationController
  
  # GET /reports
  def index
    begin
      @start = Date.new params[:start][:year].to_i, params[:start][:month].to_i, params[:start][:day].to_i
    rescue
      @start = Time.now.to_date - 365
    end
    
    begin
      @finish = Date.new params[:finish][:year].to_i, params[:finish][:month].to_i, params[:finish][:day].to_i
    rescue
      @finish = Time.now.to_date
    end
    @period = @start..@finish
    
    @income   = current_user.sum_income   @period
    @expenses = current_user.sum_expenses @period
    @net      = current_user.total_during @period
    
    @tags = current_user.items.during(@period).tag_counts :order=>'count desc', :limit=>20
    
    @run       = current_user.runs.during(@period).sum 'distance'
    @run_time  = current_user.runs.during(@period).sum 'minutes'
    
    @bike      = current_user.bikes.during(@period).sum 'distance'
    @bike_time = current_user.bikes.during(@period).sum 'minutes'
    
    @elliptical      = current_user.ellipticals.during(@period).sum 'distance'
    @elliptical_time = current_user.ellipticals.during(@period).sum 'minutes'
  end
  
end