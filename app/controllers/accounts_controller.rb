class AccountsController < ApplicationController

  # GET /accounts
  def index
  end

  # GET /accounts/:id
  def show
    @account = @household.accounts.find params[:id]
    @transactions = @account.transactions.page params[:page]
  end

end