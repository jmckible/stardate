class AccountsController < ApplicationController

  def index
    @missing = Current.household.transactions.where('debit_id IS NULL OR credit_id IS NULL')
  end

  def retired
  end

  def show
    @account = Current.household.accounts.find params[:id]
    @transactions = @account.transactions.since(Current.user.created_at).order(date: :desc).page params[:page]
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
