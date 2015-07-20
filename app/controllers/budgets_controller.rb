class BudgetsController < ApplicationController

  # GET /budgets
  def index
    @budgets = @household.budgets.order('amount DESC')
  end

  # GET /budgets/new
  def new
    @budget = Budget.new
    render layout: false
  end

  # GET /budgets/:id
  def show
    @budget = @household.budgets.find params[:id]

    begin
      @start = Date.new params[:start][:year].to_i, params[:start][:month].to_i, params[:start][:day].to_i
    rescue
      @start = Time.now.to_date - 30
    end

    begin
      @finish = Date.new params[:finish][:year].to_i, params[:finish][:month].to_i, params[:finish][:day].to_i
    rescue
      @finish = Time.now.to_date
    end

    @start = @user.created_at.to_date if @start < @user.created_at.to_date
    @period = @start..@finish

    @transactions = @household.transactions.tagged_with(@budget.tags).during(@period).page(params[:page])

    @expected = @budget.expected_during @period
    @value = @household.transactions.tagged_with(@budget.tags).during(@period).sum(&:value)
    @count = @household.transactions.tagged_with(@budget.tags).during(@period).count
  end

  # GET /budgets/:id/edit
  def edit
    @budget = @household.budgets.find params[:id]
    render layout: false
  end

  # POST /budgets
  def create
    @budget = @household.budgets.build budget_params
    @budget.save
    redirect_to budgets_url
  end

  # PUT /budgets/:id
  def update
    @budget = @household.budgets.find params[:id]
    @budget.update_attributes budget_params
    redirect_to budgets_url
  end

  # DELETE /budgets/:id
  def destroy
    @budget = @household.budgets.find params[:id]
    @budget.destroy
    redirect_to budgets_url
  end

  protected
  def budget_params
    params.require(:budget).permit!
  end

end
