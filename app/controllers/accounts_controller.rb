class AccountsController < ApplicationController

  def index
    @missing = Current.household.transactions
      .where('debit_id IS NULL OR credit_id IS NULL')
      .includes(:vendor, :tags, :debit, :credit)

    # Use SQL aggregation to compute balances efficiently
    @cash_accounts = Current.household.accounts.active.asset.earmark
      .or(Account.where(id: Current.household.checking.id))
      .reorder(budget: :desc)
      .with_balances

    @other_assets = Current.household.accounts.active.asset
      .where(earmark: false)
      .where.not(id: Current.household.checking.id)
      .with_balances

    @expense_accounts = Current.household.accounts.expense.active
      .with_balances

    @liability_accounts = Current.household.accounts.liability.active
      .with_balances

    @income_accounts = Current.household.accounts.income.active
      .with_balances
  end

  def retired
    @retired_assets = Current.household.accounts.retired.asset.with_balances
    @retired_expenses = Current.household.accounts.retired.expense.with_balances
    @retired_income = Current.household.accounts.retired.income.with_balances
  end

  def show
    @account = Current.household.accounts.find params[:id]
    @transactions = @account.transactions.since(Current.user.created_at)
      .includes(:vendor, :tags, :debit, :credit)
      .order(date: :desc)
      .page params[:page]
  end

  def new
    @account = Current.household.accounts.build
  end

  def edit
    @account = Current.household.accounts.find params[:id]
  end

  def fund
    @account = Current.household.accounts.find params[:id]
    @transaction = Current.household.transactions.build debit: @account
    render layout: false
  end

  def create
    @account = Current.household.accounts.build account_params
    @account.save
    redirect_to @account
  end

  def update
    @account = Current.household.accounts.find params[:id]
    @account.update account_params
    redirect_to @account
  end

  protected
  def account_params
    params.fetch(:account, {}).permit(:accruing, :budget, :earmark, :dashboard, :deferral_id, :ledger, :name, :status, :tag_list)
  end

end
