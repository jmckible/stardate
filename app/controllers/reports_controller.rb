class ReportsController < ApplicationController

  # GET /reports
  def index
    set_period

    @income   = @household.sum_income   @period
    @expenses = @household.sum_expenses @period
    @net      = @household.total_during @period
  end

end
