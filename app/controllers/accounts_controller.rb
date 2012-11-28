class AccountsController < ApplicationController

  # GET /accounts
  def index
  end

  # GET /accounts/new
  def new
    @account = @household.accounts.build
    render layout: false
  end

  # GET /accounts/:id
  def show
    @account = @household.accounts.find params[:id]
    @transactions = @account.transactions.page params[:page]
  end

  # GET /accounts/:id/edit
  def edit
    @account = @household.accounts.find params[:id]
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