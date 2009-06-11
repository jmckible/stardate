class DateController < ApplicationController
  
  # GET /date/:year/:month/:day
  def show
    @date = Date.new params[:year].to_i, params[:month].to_i, params[:day].to_i
    @things = current_user.things_during((@date - 2)..(@date + 2)).reverse
  rescue # invalid date
    render :file=>"#{RAILS_ROOT}/public/404.html", :status=>404
  end
  
end