class HouseholdsController < ApplicationController
  
  # PUT /households/:id
  def update
    @household.update_attributes params[:household]
    redirect_to [:edit, @user]
  end
  
end