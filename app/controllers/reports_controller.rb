class ReportsController < ApplicationController

  # GET /reports
  def index
    set_period

    @income = @household.sum_income @period
    @exceptional_income = @household.sum_non_exceptional_income @period, @household.checking

    @expenses = @household.sum_expenses(@period) * -1
    @exceptional_expenses = @household.sum_non_exceptional_expenses(@period) * -1

    @net = @income + @expenses
    @exceptional_net = @exceptional_income + @exceptional_expenses

    @expense_accounts = @household.expense_accounts.where(transactions: { date: @period })
    @expense_tags     = @household.expense_tags.where(transactions: { date: @period })
  end

end
