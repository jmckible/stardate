class RegisterController < ApplicationController
  
  # GET  /register/:year/:month
  # POST /register?&date[year]=2007&date[month]=1
  def index
    if request.method == :post
      year  = params[:date][:year].to_i
      month = params[:date][:month].to_i
    else
      year  = params[:year]  ? params[:year].to_i  : Date.today.year
      month = params[:month] ? params[:month].to_i : Date.today.month
    end
    
    @period = Date.new(year, month, 1)..Date.civil(year, month, -1)
    @items  = current_user.items.during @period
  end
end
