class HouseholdsController < ApplicationController

  # PUT /households/:id
  def update
    Current.household.update params.fetch(:household, {}).permit(:checking_id, :credit_card_id, :slush_id, :general_income_id)
    redirect_to [:edit, Current.user]
  end

  # POST /households/:id/fund
  def fund
    Current.household.accounts.asset.where('budget > 0').each(&:fund)
    redirect_to things_url
  end

end
