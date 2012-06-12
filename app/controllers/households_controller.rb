class HouseholdsController < ApplicationController
  
  # PUT /households/:id
  def update
    @household.update_attributes params[:household]
    redirect_to budgets_url
  end
  
end