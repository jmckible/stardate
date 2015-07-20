class HouseholdsController < ApplicationController

  # PUT /households/:id
  def update
    @household.update_attributes params.require(:household).permit!
    redirect_to [:edit, @user]
  end

end
