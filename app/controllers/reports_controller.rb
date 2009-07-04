class ReportsController < ApplicationController
  
  # GET /reports
  def index
    @period = (Time.now.to_date - 365)..Time.now.to_date
  end
  
end