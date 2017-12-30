class HouseholdsController < ApplicationController

  # PUT /households/:id
  def update
    @household.update_attributes params.fetch(:household, {}).permit(:cash_id, :slush_id, :general_income_id)
    redirect_to [:edit, @user]
  end

end
