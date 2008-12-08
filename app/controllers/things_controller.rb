class ThingsController < ApplicationController
  
  # GET /
  def index
    @things = current_user.things_during((Time.now.to_date - 4)..Time.now.to_date)
  end
  
  # POST /things
  def create
    thing      = Grammar.parse params[:thing]
    thing.user = current_user
    thing.save
    redirect_to root_url
  end
  
end