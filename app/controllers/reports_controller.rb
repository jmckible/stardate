class ReportsController < ApplicationController

  # GET /reports
  def index
    set_period

    @income      = @household.sum_income @period
    @exceptional = @household.transactions.income_credit.during(@period).where(exceptional: true).sum(:amount)
    @expenses    = @household.sum_expenses(@period) * -1
    @net         = @income + @expenses

    @expense_accounts = @household.expense_accounts.where(transactions: { date: @period })
  end

end
