class ReportsController < ApplicationController

  # GET /reports
  def index
    set_period

    @income = Current.household.sum_income @period
    @exceptional_income = Current.household.sum_non_exceptional_income @period, Current.household.checking

    @expenses = Current.household.sum_expenses(@period) * -1
    @exceptional_expenses = Current.household.sum_non_exceptional_expenses(@period) * -1

    @net = @income + @expenses
    @exceptional_net = @exceptional_income + @exceptional_expenses

    @expense_accounts = Current.household.expense_accounts.where(transactions: { date: @period })
    @expense_tags     = Current.household.expense_tags.where(transactions: { date: @period })
  end

end
