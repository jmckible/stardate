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
  end
  
  # POST /budgets
  def create
    @budget = @household.budgets.build params[:budget]
    @budget.save!
    redirect_to budgets_url
  end
  
  # DELETE /budgets/:id
  def destroy
    @budget = @household.budgets.find params[:id]
    @budget.destroy
    redirect_to budgets_url
  end
  
end