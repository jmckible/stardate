class HouseholdsController < ApplicationController

  # PUT /households/:id
  def update
    @household.update params.fetch(:household, {}).permit(:checking_id, :credit_card_id, :slush_id, :general_income_id)
    redirect_to [:edit, @user]
  end

  # POST /households/:id/fund
  def fund
    @household.accounts.asset.where('budget > 0').each(&:fund)
    redirect_to things_url
  end

end
