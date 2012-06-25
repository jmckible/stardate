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
    
    @start = @user.created_at.to_date if @start < @user.created_at.to_date
    @period = @start..@finish
    
    
    @income   = @household.sum_income   @period
    @expenses = @household.sum_expenses @period
    @net      = @household.total_during @period
    
    #@tags = @user.items.during(@period).tag_counts :order=>'count desc', :limit=>20
  end
  
end