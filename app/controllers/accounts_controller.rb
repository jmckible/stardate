class AccountsController < ApplicationController

  # GET /accounts
  def index
    @missing = @household.transactions.where('debit_id IS NULL OR credit_id IS NULL')
  end

  # GET /accounts/retired
  def retired
  end

  # GET /accounts/new
  def new
    @account = @household.accounts.build
  end

  # GET /accounts/:id
  def show
    @account = @household.accounts.find params[:id]
    @transactions = @account.transactions.since(@user.created_at).order(date: :desc).page params[:page]
  end

  # GET /accounts/:id/edit
  def edit
    @account = @household.accounts.find params[:id]
  end

  # GET /accounts/:id/fund
  def fund
    @account = @household.accounts.find params[:id]
    @transaction = @household.transactions.build debit: @account
    render layout: false
  end

  # POST /accounts
  def create
    @account = @household.accounts.build account_params
    @account.save
    redirect_to @account
  end

  # PUT /accounts/:id
  def update
    @account = @household.accounts.find params[:id]
    @account.update account_params
    redirect_to @account
  end

  protected
  def account_params
    params.fetch(:account, {}).permit(:accruing, :budget, :earmark, :dashboard, :deferral_id, :ledger, :name, :status, :tag_list)
  end

end
