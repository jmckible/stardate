class ThingsController < ApplicationController
  
  # GET /
  def index
    @things = current_user.stuff_during((Date.today - 7)..Date.today)
  end
  
  # POST /things
  def create
    thing      = Grammar.parse params[:thing]
    thing.user = current_user
    thing.save
    redirect_to root_url
  end
  
end