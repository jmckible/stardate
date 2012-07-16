class ThingsController < ApplicationController
  
  # GET /
  def index
    @things = @user.things_during((Time.now.to_date - 4)..Time.now.to_date)
    @month  = (Date.today - 30)..Date.today
  end
  
  # GET /things/new
  def new
    render layout: false
  end
  
  # POST /things
  def create
    @thing = Grammar.parse params[:thing]
    @thing.user = @user
    @thing.household = @household if @thing.is_a?(Item)
    @thing.save!
    redirect_to root_url
  end
  
end