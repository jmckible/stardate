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
    
    @miles   = current_user.runs.during(@period).sum 'distance'
    @minutes = current_user.runs.during(@period).sum 'minutes'
  end
  
end