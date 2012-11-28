class TransactionsController < ApplicationController

  # # GET /items
  # def index
  #   if params[:date]
  #     year  = params[:date][:year]  ? params[:date][:year].to_i  : Date.today.year
  #     month = params[:date][:month] ? params[:date][:month].to_i : Date.today.month
  #   else
  #     year = Date.today.year
  #     month = Date.today.month
  #   end
    
  #   @period = Date.new(year, month, 1)..Date.civil(year, month, -1)
    
  #   if @period.first < @user.created_at.to_date
  #     @period = @user.created_at.beginning_of_month.to_date..@user.created_at.end_of_month.to_date
  #   end
    
  #   @items = @household.items.during @period
  # end

  # GET /transactions/:id
  def show
    @transaction = @household.transactions.find params[:id]
    render layout: false
  end

  # POST /transactions/:id
  def create
    @transaction = @household.transactions.build params[:transaction]
    @transaction.user = @user
    @transaction.save
    redirect_back_or @transaction.credit
  end

  # PUT /items/:id
  def update
    @transaction = @household.transactions.find params[:id]
    @transaction.update_attributes! params[:transaction]
    redirect_back_or root_url
  end

  # DELETE /transaction/:id
  def destroy
    @transaction = @household.transactions.find params[:id]
    @transaction.destroy
    redirect_back_or root_url
  end

end
