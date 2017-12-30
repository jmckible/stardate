class ThingsController < ApplicationController

  # GET /
  def index
    @things = @user.things_during((Time.zone.now.to_date - 4)..Time.zone.now.to_date)
    @month  = (Time.zone.today - 30)..Time.zone.today
  end

  # GET /things/new
  def new
    render layout: false
  end

  # POST /things
  def create
    @thing = Grammar.parse params[:thing], @household
    @thing.user = @user
    @thing.save!
    redirect_to root_url
  end

end
