class ThingsController < ApplicationController

  def index
    @things = Current.user.things_during((Time.zone.now.to_date - 4)..Time.zone.now.to_date)
    @month  = (Time.zone.today - 30)..Time.zone.today
  end

  def new
    render layout: false
  end

  def create
    @thing = Grammar.parse params[:thing], Current.user
    @thing.user = Current.user
    @thing.save!
    redirect_to root_url
  end

end
