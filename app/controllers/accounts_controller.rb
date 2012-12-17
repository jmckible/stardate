class AccountsController < ApplicationController

  # GET /accounts
  def index
    @missing = @household.transactions.where('debit_id is null or credit_id is null')
  end

  # GET /accounts/new
  def new
    @account = @household.accounts.build
    render layout: false
  end

  # GET /accounts/:id
  def show
    @account = @household.accounts.find params[:id]
    @transactions = @account.transactions.order('date DESC').where('transactions.date >= ?', @user.created_at).page params[:page]
  end

  # GET /accounts/:id/edit
  def edit
    @account = @household.accounts.find params[:id]
    render layout: false
  end

  # GET /accounts/:id/fund
  def fund
    @account = @household.accounts.find params[:id]
    @transaction = @household.transactions.build debit: @account
    render layout: false
  end

  # POST /accounts
  def create
    @account = @household.accounts.build params[:account]
    @account.save
    redirect_to @account
  end

  # PUT /accounts/:id
  def update
    @account = @household.accounts.find params[:id]
    @account.update_attributes params[:account]
    redirect_to @account
  end

end