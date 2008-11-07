class ThingsController < ApplicationController
  
  # POST /things
  def create
    thing      = Grammar.parse params[:thing]
    thing.user = current_user
    thing.save
    redirect_to root_url
  end
  
end