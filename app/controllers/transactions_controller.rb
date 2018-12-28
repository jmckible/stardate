class TransactionsController < ApplicationController

  # GET /transactions
  def index
    if params[:date]
      year  = params[:date][:year]  ? params[:date][:year].to_i  : Time.zone.today.year
      month = params[:date][:month] ? params[:date][:month].to_i : Time.zone.today.month
    else
      year  = Time.zone.today.year
      month = Time.zone.today.month
    end

    @period = Date.new(year, month, 1)..Date.civil(year, month, -1)

    if @period.first < @user.created_at.to_date
      @period = @user.created_at.beginning_of_month.to_date..@user.created_at.end_of_month.to_date
    end

    @transactions = @household.transactions.during @period
  end

  # GET /transactions/:id
  def show
    @transaction = @household.transactions.find params[:id]
    render layout: false
  end

  # POST /transactions/:id
  def create
    @transaction = @household.transactions.build transaction_params
    @transaction.user = @user
    @transaction.save
    redirect_back_or @transaction.credit
  end

  # PUT /transactions/:id
  def update
    @transaction = @household.transactions.find params[:id]
    @transaction.update! transaction_params
    redirect_back_or root_url
  end

  # DELETE /transaction/:id
  def destroy
    @transaction = @household.transactions.find params[:id]
    @transaction.destroy
    redirect_back_or root_url
  end

  protected
  def transaction_params
    params.require(:transaction).permit(:amount, :credit_id, :date, :debit_id, :description, :exceptional, :tag_list, :secret, :vendor_name)
  end

end
