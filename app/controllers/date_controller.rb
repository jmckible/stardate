class DateController < ApplicationController

  # GET /date/:year/:month/:day
  def show
    @date = Date.new params[:year].to_i, params[:month].to_i, params[:day].to_i
    @things = Current.user.things_during((@date - 2)..(@date + 2)).reverse
  rescue ArgumentError # Invalid date
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

end
