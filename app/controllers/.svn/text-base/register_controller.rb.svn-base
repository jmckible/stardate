class RegisterController < ApplicationController
  
  # GET  /register/2007/1
  # POST /register?&date[year]=2007&date[month]=1
  def index
    if request.method == :post
      year = params[:date][:year].to_i
      month = params[:date][:month].to_i
      start = Date.new(year, month, 1)
      ending = Date.civil(year, month, -1)
      @period = start..ending
    else
      period_assign_whole_month
    end
  end
end
