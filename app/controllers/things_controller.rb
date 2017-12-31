class ThingsController < ApplicationController

  # GET /
  def index
    @things = @user.things_during((Time.zone.now.to_date - 4)..Time.zone.now.to_date)
    @month  = (Time.zone.today - 30)..Time.zone.today

    @spending_chart = { series: [
      {
        name: 'Income',
        data: @month.collect{|date| @household.cash_income @month.first..date},
        pointInterval: 24 * 3600 * 1000,
        pointStart: (@month.first.to_time.to_f * 1000),
        color: '#00CCFF'
      },
      {
        name: 'Expense',
        data:  @month.collect{|date| @household.sum_non_exceptional_expenses(@month.first..date)},
        pointInterval: 24 * 3600 * 1000,
        pointStart: (@month.first.to_time.to_f * 1000),
        color: '#FF00CC'
      }
    ].to_json}
  end

  # GET /things/new
  def new
    render layout: false
  end

  # POST /things
  def create
    @thing = Grammar.parse params[:thing], @household
    @thing.user = @user
    @thing.save!
    redirect_to root_url
  end

end
