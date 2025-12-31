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

    @duration = (@finish - @start + 1).to_i

    @expense_accounts = Current.household.expense_accounts.where(transactions: { date: @period })
    @expense_tags     = Tag
      .joins("INNER JOIN taggings ON tags.id = taggings.tag_id AND taggings.taggable_type = 'Transaction'")
      .joins('INNER JOIN transactions ON taggings.taggable_id = transactions.id')
      .joins('INNER JOIN accounts ON transactions.debit_id = accounts.id')
      .where(transactions: { household_id: Current.household.id, date: @period })
      .where('accounts.ledger = ?', Account.ledgers[:expense])
      .select('tags.*, COUNT(transactions.debit_id) AS transaction_count, SUM(transactions.amount) AS total')
      .group('tags.id')
      .order(total: :desc)

    # Create lookup hashes for non-exceptional totals
    @non_exceptional_account_totals = Current.household.transactions
      .where(date: @period, exceptional: false)
      .joins('INNER JOIN accounts ON transactions.debit_id = accounts.id')
      .where('accounts.ledger = ?', Account.ledgers[:expense])
      .group('accounts.id')
      .sum(:amount)

    @non_exceptional_tag_totals = Current.household.transactions
      .where(date: @period, exceptional: false)
      .joins("INNER JOIN taggings ON transactions.id = taggings.taggable_id AND taggings.taggable_type = 'Transaction'")
      .joins('INNER JOIN accounts ON transactions.debit_id = accounts.id')
      .where('accounts.ledger = ?', Account.ledgers[:expense])
      .group('taggings.tag_id')
      .sum(:amount)
  end

end
